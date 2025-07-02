import { appendDir } from '@common/endpoint-utils.js'
import { Result, SubmissionRow, TestDefinitionRow } from '@common/interfaces.js'
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
    this.attachGet('/submissions/:uuid', this.getSubmissionByUuid)
    this.attachGet('/submissions/:uuid/results', this.getSubmissionByUuidResults)
    this.attachPatch('/result', this.patchResult)
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
   *              benchmark_definition_id:
   *                type: string
   *                format: uuid
   *                description: ID of benchmark this submission belongs to.
   *              submission_data_url:
   *                type: string
   *                description: URL of submission executable image.
   *              code_repository:
   *                type: string
   *                description: URL of submission code repository.
   *              test_definition_ids:
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
          benchmark_definition_id,
          test_definition_ids,
          name,
          submission_data_url,
          code_repository,
          submitted_at,
          submitted_by,
          submitted_by_username
        ) VALUES (
          ${req.body.benchmark_definition_id},
          ${req.body.test_definition_ids},
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
        WHERE id=ANY(${req.body.test_definition_ids})
        LIMIT ${req.body.test_definition_ids!.length}
      `
    // if required (not all OFFLINE), send message with test names to evaluator
    if (tests.some((test) => test.loop !== 'OFFLINE')) {
      const celery = CeleryService.getInstance()
      const payload = {
        submission_data_url: req.body.submission_data_url,
        // TODO we should only send non-OFFLINE tests
        tests: tests.map((test) => test.name),
      }
      logger.info(`Sending ${payload} to celery.`)
      try {
        // the returned unsettled promise is ignored and continues running (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
        celery.sendTask(req.body.benchmark_definition_id as string, payload, id)
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
   *      - oauth2: [user]
   *    parameters:
   *      - in: query
   *        name: benchmark
   *        schema:
   *          type: string
   *          format: uuid
   *        description: Filter submissions by benchmark.
   *      - in: query
   *        name: submitted_by
   *        schema:
   *          type: string
   *          format: uuid
   *        description: Filter submissions by user. If this equals the authenticated user, un-published submissions will be listed too.
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
   *                          benchmark_definition_id:
   *                            type: string
   *                            format: uuid
   *                          test_definition_ids:
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
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }

    const benchmarkId = req.query['benchmark']
    const submittedBy = req.query['submitted_by']

    const sql = SqlService.getInstance()

    // per default, list all public submissions
    let wherePublic = sql.fragment`published = true`
    let whereBenchmark = sql.fragment`1=1`
    let whereSubmittedBy = sql.fragment`1=1`
    if (benchmarkId) {
      whereBenchmark = sql.fragment`benchmark_definition_id=${benchmarkId}`
    }
    if (submittedBy) {
      // turn off public requirement if submitter matches authorized user
      if (submittedBy === auth.sub) {
        wherePublic = sql.fragment`1=1`
      }
      whereSubmittedBy = sql.fragment`submitted_by=${submittedBy}`
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
   * /submissions/{uuid}:
   *  get:
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: uuid
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *        description: The submission ID
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
   *                          benchmark_definition_id:
   *                            type: string
   *                            format: uuid
   *                          test_definition_ids:
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
  getSubmissionByUuid: GetHandler<'/submissions/:uuid'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const uuids = req.params.uuid.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<SubmissionRow>>`
        SELECT * FROM submissions
        WHERE id=ANY(${uuids})
        LIMIT ${uuids.length}
      `
    const submissions = appendDir('/submissions/', rows)
    // return array - dev.002
    this.respond(req, res, submissions)
  }

  getSubmissionByUuidResults: GetHandler<'/submissions/:uuid/results'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const uuid = req.params.uuid
    const sql = SqlService.getInstance()
    const [row] = await sql.query<StripDir<Result>>`
      SELECT * FROM results
      WHERE submission_uuid=${uuid}
    `
    const results = appendDir('/results/', [row])
    this.respond(req, res, results)
  }

  patchResult: PatchHandler<'/result'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }

    const uuid = req.body.uuid
    // restrict to patchable fields
    const patch = {
      public: req.body.public,
    }
    const sql = SqlService.getInstance()
    const [row] = await sql.query<StripDir<Result>>`
      UPDATE results SET ${sql.fragment(patch, 'public')}
        WHERE uuid=${uuid}
        RETURNING *
    `

    const [result] = appendDir('/results/', [row])
    this.respond(req, res, result)
  }
}
