import { SubmissionRow, TestDefinitionRow } from '@common/interfaces.js'
import { StripId } from '@common/utility-types'
import { StatusCodes } from 'http-status-codes'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { CeleryService } from '../services/celery-client-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { ControllerError } from './controller-utils.mjs'
import { Controller, GetHandler, PatchHandler, PostHandler } from './controller.mjs'

const logger = new Logger('submission-controller')

export class SubmissionController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachPost('/submissions', this.postSubmission, { authorizedRoles: ['User'] })
    this.attachGet('/submissions', this.getSubmissions)
    this.attachGet('/submissions/own', this.getOwnSubmissions, { authorizedRoles: ['User'] })
    this.attachGet('/submissions/:submission_ids', this.getSubmissionByUuid)
    this.attachPatch('/submissions/:submission_ids', this.patchSubmissionByUuid, { authorizedRoles: ['User'] })
  }

  /**
   * @swagger
   * /submissions:
   *  post:
   *    description: Inserts new submission.
   *    security:
   *      - oauth2: [user]
   *    requestBody:
   *      required: true
   *      content:
   *        application/json:
   *          schema:
   *            type: object
   *            properties:
   *              name:
   *                type: string
   *                description: Display name of submission.
   *              benchmark_id:
   *                type: string
   *                format: uuid
   *                description: ID of benchmark this submission belongs to.
   *              submission_data_url:
   *                type: string
   *                description: URL of submission executable image.
   *              code_repository:
   *                type: string
   *                description: URL of submission code repository.
   *              test_ids:
   *                type: array
   *                items:
   *                  type: string
   *                  format: uuid
   *                description: IDs of tests to run.
   *            required:
   *              - name
   *              - benchmark_id
   *              - test_ids
   *    responses:
   *      200:
   *        description: Created.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                        type: object
   *                        properties:
   *                          id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of submission.
   */
  postSubmission: PostHandler<'/submissions'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = (await authService.authorization(req))!
    this.checkCompleteness(req.body)
    await this.checkValidity(req.body)
    // save submission in db
    const sql = SqlService.getInstance()
    const idRow = await sql.query`
        INSERT INTO submissions (
          benchmark_id,
          test_ids,
          name,
          submission_data_url,
          code_repository,
          submitted_at,
          submitted_by,
          submitted_by_username
        ) VALUES (
          ${req.body.benchmark_id},
          ${req.body.test_ids},
          ${req.body.name},
          ${req.body.submission_data_url},
          ${req.body.code_repository ?? null},
          current_timestamp,
          ${auth.sub ?? null},
          ${auth['preferred_username'] ?? null}
        )
        RETURNING id
      `
    const id: string | undefined = idRow.at(0)?.['id']
    if (!id) {
      this.respondError(req, res, { text: `could not insert submission` }, undefined, { id })
      return
    }
    // get tests
    const tests = await sql.query<TestDefinitionRow>`
        SELECT * FROM tests
        WHERE id=ANY(${req.body.test_ids})
        LIMIT ${req.body.test_ids!.length}
      `
    // if required (not all OFFLINE), send message with test names to evaluator
    if (tests.some((test) => test.loop !== 'OFFLINE')) {
      const celery = CeleryService.getInstance()
      const payload = {
        submission_data_url: req.body.submission_data_url,
        // TODO we should only send non-OFFLINE tests
        tests: tests.map((test) => test.id),
      }
      let queue
      if (tests.length == 1 && tests[0].queue) {
        queue = tests[0].queue
      } else {
        queue = req.body.benchmark_id as string
      }
      logger.info(`Sending ${payload} to celery into queue ${queue}.`)
      try {
        celery.sendTask(queue, payload, id)
        // request succeeds once connection is checked ready and task sent
        this.respond(req, res, { id }, payload)
      } catch (error) {
        // request fails if sendTask fails as not ready
        this.respondError(req, res, { text: error as string })
      }
    } else {
      logger.info('All tests are offline loop, no celery task sent.')
      this.respond(req, res, { id })
    }
  }

  /**
   * @swagger
   * /submissions:
   *  get:
   *    description: Lists all published submissions.
   *    parameters:
   *      - in: query
   *        name: benchmark_ids
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *        description: Filter submissions by benchmark.
   *        explode: false
   *    responses:
   *      200:
   *        description: Requested submissions.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: array
   *                      items:
   *                        type: object
   *                        properties:
   *                          id:
   *                            type: string
   *                            format: uuid
   *                          benchmark_id:
   *                            type: string
   *                            format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          submission_data_url:
   *                            type: string
   *                          code_repository:
   *                            type: string
   *                          submitted_at:
   *                            type: string
   *                          submitted_by:
   *                            type: string
   *                            format: uuid
   *                          submitted_by_username:
   *                            type: string
   *                          status:
   *                            type: string
   *                          published:
   *                            type: boolean
   */
  getSubmissions: GetHandler<'/submissions'> = async (req, res) => {
    const benchmarkIds = req.query['benchmark_ids']?.split(',')

    const sql = SqlService.getInstance()

    // per default, list for all benchmarks
    let whereBenchmark = sql.fragment`1=1`
    if (benchmarkIds) {
      whereBenchmark = sql.fragment`benchmark_id = ANY(${benchmarkIds})`
    }

    const submissions = await sql.query<SubmissionRow>`
        SELECT * FROM submissions
        WHERE
          published = true AND
          ${whereBenchmark}
      `
    this.respond(req, res, submissions)
  }

  /**
   * @swagger
   * /submissions/own:
   *  get:
   *    description: Lists own submissions.
   *    security:
   *      - oauth2: [user]
   *    responses:
   *      200:
   *        description: Requested submissions.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: array
   *                      items:
   *                        type: object
   *                        properties:
   *                          id:
   *                            type: string
   *                            format: uuid
   *                          benchmark_id:
   *                            type: string
   *                            format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          submission_data_url:
   *                            type: string
   *                          code_repository:
   *                            type: string
   *                          submitted_at:
   *                            type: string
   *                          submitted_by:
   *                            type: string
   *                            format: uuid
   *                          submitted_by_username:
   *                            type: string
   *                          status:
   *                            type: string
   *                          published:
   *                            type: boolean
   */
  getOwnSubmissions: GetHandler<'/submissions/own'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = (await authService.authorization(req))!
    const sql = SqlService.getInstance()

    const submissions = await sql.query<SubmissionRow>`
        SELECT * FROM submissions
        WHERE
          submitted_by = ${auth.sub}
      `
    this.respond(req, res, submissions)
  }

  /**
   * @swagger
   * /submissions/{submission_ids}:
   *  get:
   *    description: Get submissions.
   *    security:
   *      - {}
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: submission_ids
   *        description: Comma-separated list of submission IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *    responses:
   *      200:
   *        description: Requested submissions.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: array
   *                      items:
   *                        type: object
   *                        properties:
   *                          id:
   *                            type: string
   *                            format: uuid
   *                          benchmark_id:
   *                            type: string
   *                            format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          submission_data_url:
   *                            type: string
   *                          code_repository:
   *                            type: string
   *                          submitted_at:
   *                            type: string
   *                          submitted_by:
   *                            type: string
   *                            format: uuid
   *                          submitted_by_username:
   *                            type: string
   *                          status:
   *                            type: string
   *                          published:
   *                            type: boolean
   */
  getSubmissionByUuid: GetHandler<'/submissions/:submission_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    const uuids = req.params.submission_ids.split(',')
    const sql = SqlService.getInstance()
    // per default, list only public submissions
    let wherePublished = sql.fragment`published = true`
    if (auth?.sub) {
      wherePublished = sql.fragment`(published = true OR submitted_by = ${auth.sub})`
    }
    // id=ANY - dev.003
    const submissions = await sql.query<SubmissionRow>`
        SELECT * FROM submissions
        WHERE
          id=ANY(${uuids}) AND
          ${wherePublished}
        LIMIT ${uuids.length}
      `
    // return array - dev.002
    this.respondAfterPresenceCheck(req, res, submissions, uuids)
  }

  /**
   * @swagger
   * /submissions/{submission_ids}:
   *  description: Publish submissions.
   *  patch:
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: submission_ids
   *        description: Comma-separated list of IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *    responses:
   *      200:
   *        description: Published submission.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: array
   *                      items:
   *                        type: object
   *                        properties:
   *                          id:
   *                            type: string
   *                            format: uuid
   *                          benchmark_id:
   *                            type: string
   *                            format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          submission_data_url:
   *                            type: string
   *                          code_repository:
   *                            type: string
   *                          submitted_at:
   *                            type: string
   *                          submitted_by:
   *                            type: string
   *                            format: uuid
   *                          submitted_by_username:
   *                            type: string
   *                          status:
   *                            type: string
   *                          published:
   *                            type: boolean
   */
  patchSubmissionByUuid: PatchHandler<'/submissions/:submission_ids'> = async (req, res) => {
    logger.info(`patchSubmissionByUuid`)
    const uuids = req.params.submission_ids.split(',')
    logger.info(`patchSubmissionByUuid list ${uuids}`)
    const sql = SqlService.getInstance()
    const submissions = await sql.query<SubmissionRow>`
      UPDATE submissions SET published=true
        WHERE id=ANY(${uuids})
        RETURNING *
    `
    logger.info(`rows ${submissions}`)
    // return array - dev.002
    this.respond(req, res, submissions)
  }

  /**
   * Checks if the provided `resource` is complete.
   * @param resource Resource to check for completeness.
   * @throws {ControllerError} When check failed.
   */
  checkCompleteness(resource: StripId<SubmissionRow>) {
    // Check presence of required fields using simple nullish check to catch
    // empty strings as well.
    const missingFields: (keyof typeof resource)[] = []
    if (!resource.name) missingFields.push('name')
    if (!resource.benchmark_id) missingFields.push('benchmark_id')
    if (!resource.test_ids || resource.test_ids.length === 0) missingFields.push('test_ids')
    if (missingFields.length) {
      throw new ControllerError('Required field is missing value', missingFields, StatusCodes.BAD_REQUEST)
    }
  }

  // not using `validate` to keep the `checkX` pattern up
  /**
   * Checks if all values in the provided `resource` are valid.
   * @param resource Resource to validate.
   * @throws {ControllerError} When check failed.
   */
  async checkValidity(resource: StripId<SubmissionRow>) {
    const sql = SqlService.getInstance()
    // returns an array of all ids (in benchmark_id) without matching db row
    const benchmarkMismatches = await sql.query`
      SELECT reference
      FROM UNNEST(${[resource.benchmark_id]}::uuid[]) AS reference
      LEFT JOIN benchmarks ON id = reference
      WHERE id IS NULL
    `
    if (benchmarkMismatches.length) {
      throw new ControllerError('Referenced benchmark does not exist', benchmarkMismatches, StatusCodes.BAD_REQUEST)
    }
    const testMismatches = await sql.query`
      SELECT reference
      FROM UNNEST(${resource.test_ids}::uuid[]) AS reference
      LEFT JOIN tests ON id = reference
      WHERE id IS NULL
    `
    if (testMismatches.length) {
      throw new ControllerError('Referenced test does not exist', testMismatches, StatusCodes.BAD_REQUEST)
    }
    const testBenchRelMismatches = await sql.query`
      SELECT reference
      FROM UNNEST(${resource.test_ids}::uuid[]) AS reference
      LEFT JOIN tests ON id = reference
      LEFT JOIN benchmarks ON tests.id = ANY(benchmarks.test_ids)
      WHERE benchmarks.id != ${resource.benchmark_id}
    `
    if (testBenchRelMismatches.length) {
      throw new ControllerError(
        'Referenced test does not exist in benchmark',
        testBenchRelMismatches,
        StatusCodes.BAD_REQUEST,
      )
    }
  }
}
