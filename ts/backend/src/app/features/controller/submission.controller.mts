import { appendDir } from '@common/endpoint-utils.js'
import { SubmissionRow, TestDefinitionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { CeleryService } from '../services/celery-client-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler, PatchHandler, PostHandler } from './controller.mjs'

const logger = new Logger('submission-controller')

export class SubmissionController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachPost('/submissions', this.postSubmission)
    this.attachGet('/submissions', this.getSubmissions)
    this.attachGet('/submissions/:submission_ids', this.getSubmissionByUuid)
    this.attachPatch('/submissions/:submission_ids', this.patchSubmissionByUuid)
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
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
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
      this.serverError(req, res, { text: `could not insert submission` }, { id })
      return
    }
    // get tests
    const tests = await sql.query<TestDefinitionRow>`
        SELECT * FROM test_definitions
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
        this.serverError(req, res, { text: error as string })
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
   *    security:
   *      - {}
   *      - oauth2: [user]
   *    parameters:
   *      - in: query
   *        name: benchmark_ids
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *        description: Filter submissions by benchmark.
   *      - in: query
   *        name: submitted_by
   *        schema:
   *          type: string
   *          format: uuid
   *        description: Filter submissions by user.
   *      - in: query
   *        name: unpublished_own
   *        schema:
   *          type: string
   *        description: Either `true` or `false` (default), literally and case-sensitive. If `true`, un-published submissions owned by the authenticated user are not filtered out.
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
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)

    const benchmarkId = req.query['benchmark_ids']
    const submittedBy = req.query['submitted_by']
    let unpublishedOwn = false
    if (req.query['unpublished_own'] === 'true') {
      unpublishedOwn = true
    } else if (req.query['unpublished_own'] !== 'false') {
      this.requestError(req, res, { text: `invalid value "${req.query['unpublished_own']}" for "unpublished_own"` })
      return
    }

    const sql = SqlService.getInstance()

    // per default, list all public submissions
    let wherePublic = sql.fragment`published = true`
    let whereBenchmark = sql.fragment`1=1`
    let whereSubmittedBy = sql.fragment`1=1`
    if (benchmarkId) {
      // TODO https://github.com/flatland-association/flatland-benchmarks/issues/317 support multiple benchmark_ids
      whereBenchmark = sql.fragment`benchmark_id=${benchmarkId}`
    }
    if (submittedBy) {
      whereSubmittedBy = sql.fragment`submitted_by=${submittedBy}`
    }
    if (unpublishedOwn && auth?.sub) {
      // bypass published requirement for own submissions only
      wherePublic = sql.fragment`(published = true OR submitted_by = ${auth.sub})`
    }

    const rows = await sql.query<StripDir<SubmissionRow>>`
        SELECT * FROM submissions
        WHERE
          ${wherePublic} AND
          ${whereBenchmark} AND
          ${whereSubmittedBy}
      `
    const resources = appendDir('/submissions/', rows)
    this.respond(req, res, resources)
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
    let wherePublic = sql.fragment`published = true`
    if (auth?.sub) {
      wherePublic = sql.fragment`(published = true OR submitted_by = ${auth.sub})`
    }
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<SubmissionRow>>`
        SELECT * FROM submissions
        WHERE
          id=ANY(${uuids}) AND
          ${wherePublic}
        LIMIT ${uuids.length}
      `
    const submissions = appendDir('/submissions/', rows)
    // return array - dev.002
    this.respond(req, res, submissions)
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
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }

    const uuids = req.params.submission_ids.split(',')
    logger.info(`patchSubmissionByUuid list ${uuids}`)
    const sql = SqlService.getInstance()
    const rows = await sql.query<StripDir<SubmissionRow>>`
      UPDATE submissions SET published=true
        WHERE id=ANY(${uuids})
        RETURNING *
    `
    logger.info(`rows ${rows}`)

    const submissions = appendDir('/submissions/', rows)
    // return array - dev.002
    this.respond(req, res, submissions)
  }
}
