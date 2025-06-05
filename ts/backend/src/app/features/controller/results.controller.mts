import { ResultRow } from '@common/interfaces'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { dbgSqlState, SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler, PostHandler } from './controller.mjs'

const logger = new Logger('results-controller')

export class ResultsController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/results/submission/:submission_id/tests/:test_id', this.getTestResults)
    this.attachPost('/results/submission/:submission_id/tests/:test_id', this.postTestResults)
  }

  /**
   * @swagger
   * /results/submission/{submission_id}/tests/{test_id}:
   *  get:
   *    description: Get submission results aggregated by test.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: submission_id
   *        description: Submission ID.
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *      - in: path
   *        name: test_id
   *        description: Test ID.
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   */
  getTestResults: GetHandler<'/results/submission/:submission_id/tests/:test_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    const sql = SqlService.getInstance()
    const submissionId = req.params.submission_id
    const testId = req.params.test_id
    // load all rows of results for that submission/test
    const rows = await sql.query`
      SELECT * FROM results WHERE test_definition_id=${testId} AND submission_id=${submissionId}
    `
    this.respond(res, rows, dbgSqlState(sql))
  }

  /**
   * @swagger
   * /results/submission/{submission_id}/tests/{test_id}:
   *  post:
   *    description: Inserts test results
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: submission_id
   *        description: Submission ID.
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *      - in: path
   *        name: test_id
   *        description: Test UUID.
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *    requestBody:
   *      required: true
   *      content:
   *        application/json:
   *          schema:
   *            type: object
   *            properties:
   *              data:
   *                type: array
   *                description: Results.
   *                items:
   *                  type: object
   *                  properties:
   *                    scenario_id:
   *                      type: string
   *                      format: uuid
   *                      description: UUID of scenario
   *                  additionalProperties:
   *                    type: number
   *    responses:
   *      200:
   *        description: All results inserted.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *      400:
   *        description: Some results could not be inserted, transaction aborted.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   */
  postTestResults: PostHandler<'/results/submission/:submission_id/tests/:test_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id
    const testId = req.params.test_id
    const resultRows = req.body.data.flatMap((score) => {
      const resultRows: ResultRow[] = []
      // score's keys are keys of score, except for the one being scenario_id, which is scenario_id
      for (const key in score) {
        if (key != 'scenario_id') {
          resultRows.push({
            scenario_definition_id: score.scenario_id,
            test_definition_id: testId,
            submission_id: submissionId,
            key,
            value: score[key],
          })
        }
      }
      return resultRows
    })
    // TODO: check that all defined fields are present
    // save in db
    const sql = SqlService.getInstance()
    // TODO: abstract transaction as `sql.transactionQuery` or similar...
    await sql.query`BEGIN`
    await sql.query`
      INSERT INTO results ${sql.fragment(resultRows)}
    `
    const ok = !sql.errors
    if (ok) {
      await sql.query`COMMIT`
      this.respond(res, {})
    } else {
      this.requestError(res, { text: 'Some results could not be inserted, transaction aborted.' })
    }
  }
}
