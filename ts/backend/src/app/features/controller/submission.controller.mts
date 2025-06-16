import { appendDir } from '@common/endpoint-utils.js'
import { Result, SubmissionPreview, SubmissionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { createClient } from 'redis'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { CeleryService } from '../services/celery-client-service.mjs'
import { AuthService } from '../services/auth-service.mjs'
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
   *  get:
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: query
   *        name: benchmark
   *        schema:
   *          type: string
   *        description: The number of items to skip before starting to collect the result set
   *    responses:
   *      200:
   *        description: Requested tests.
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
   *                          uuid:
   *                            type: string
   *                            format: uuid
   *                          name:
   *                            type: string
   *                          benchmark:
   *                            type: string
   *                          submitted_at:
   *                            type: string
   *                          submitted_by_username:
   *                            type: string
   *                          public:
   *                            type: string
   *                          scores:
   *                            type: string
   *                          rank:
   *                            type: string
   */
  postSubmission: PostHandler<'/submissions'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
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
      this.serverError(res, { text: `could not insert submission` }, { id })
      return
    }
    // get test names
    const tests = (
      await sql.query<{ name: string }>`
          SELECT name FROM test_definitions
          WHERE id=ANY(${req.body.test_definition_ids})
          LIMIT ${req.body.test_definition_ids!.length}
        `
    ).map((r) => r.name)
    // start evaluator
    const celery = CeleryService.getInstance()
    const payload = {
      submission_data_url: req.body.submission_data_url,
      tests: tests,
    }
    logger.info(`Sending ${payload} to celery.`)
    const sent = await celery.sendTask(req.body.benchmark_definition_id as string, payload, id)
    if (sent) {
      this.respond(res, { id }, payload)
    } else {
      this.respond(res, { id }, 'Could not send message to broker. Check backend log.')
    }
  }

  // returns scored and public submissions as preview
  getSubmissions: GetHandler<'/submissions'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }

    const benchmarkId = req.query['benchmark']
    const submissionIds = req.query['uuid']?.split(',')
    const submittedBy = req.query['submitted_by']

    const sql = SqlService.getInstance()

    let whereScores = sql.fragment`scores IS NOT NULL`
    let wherePublic = sql.fragment`public = true`
    const whereBenchmark = benchmarkId ? sql.fragment`benchmark=${benchmarkId}` : sql.fragment`1=1`
    let whereSubmission = sql.fragment`1=1`
    let whereSubmittedBy = sql.fragment`1=1`
    let limit = sql.fragment`LIMIT 3`
    if (submissionIds) {
      // turn off scores and public requirements if id is given
      whereScores = sql.fragment`1=1`
      wherePublic = sql.fragment`1=1`
      whereSubmission = sql.fragment`submissions.uuid=ANY(${submissionIds})`
      limit = sql.fragment`LIMIT ${submissionIds.length}`
    }
    if (submittedBy) {
      // turn off limit, scores and public requirements if submitter is given
      whereScores = sql.fragment`1=1`
      wherePublic = sql.fragment`1=1`
      whereSubmittedBy = sql.fragment`submitted_by=${submittedBy}`
      limit = sql.fragment``
    }

    const rows = await sql.query<StripDir<SubmissionPreview>>`
        SELECT submissions.id, submissions.uuid, name, benchmark, submitted_at, submitted_by_username, public, scores, rank
          FROM (
            SELECT submissions.id, submissions.uuid, name, benchmark, submitted_at, submitted_by_username, public, scores, rank() OVER(PARTITION BY benchmark, public ORDER BY scores[1] DESC) AS rank, submitted_by
              FROM submissions
              LEFT JOIN results ON results.submission_uuid = submissions.uuid
          ) AS submissions
          WHERE
            ${whereScores} AND
            ${wherePublic} AND
            ${whereBenchmark} AND
            ${whereSubmission} AND
            ${whereSubmittedBy}
          ORDER BY scores[1] DESC
          ${limit}
      `
    const resources = appendDir('/submissions/', rows)
    this.respond(res, resources)
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
   *                          submitted_at:
   *                            type: string
   *                          submitted_by_username:
   *                            type: string
   *                          public:
   *                            type: string
   *                          scores:
   *                            type: string
   *                          rank:
   *                            type: string
   */
  getSubmissionByUuid: GetHandler<'/submissions/:uuid'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
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
    this.respond(res, submissions)
  }

  getSubmissionByUuidResults: GetHandler<'/submissions/:uuid/results'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    const uuid = req.params.uuid
    const sql = SqlService.getInstance()
    const [row] = await sql.query<StripDir<Result>>`
      SELECT * FROM results
      WHERE submission_uuid=${uuid}
    `
    const results = appendDir('/results/', [row])
    this.respond(res, results)
  }

  patchResult: PatchHandler<'/result'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
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
    this.respond(res, result)
  }
}
