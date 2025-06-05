import { FieldDefinitionRow, ResultRow, ScenarioDefinitionRow, TestDefinitionRow } from '@common/interfaces'
import { json } from '@common/utility-types'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Aggregator, upcastScenarioDefinitionRow, upcastTestDefinitionRow } from '../utils/aggregator.mjs'
import { Controller, GetHandler, PostHandler } from './controller.mjs'

const logger = new Logger('results-controller')

export class ResultsController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/results/submission/:submission_id/tests/:test_id', this.getTestResults)
    this.attachPost('/results/submission/:submission_id/tests/:test_id', this.postTestResults)
    this.attachGet('/results/submission/:submission_id/tests/:test_id/scenario/:scenario_id', this.getScenarioResults)
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
   *    responses:
   *      200:
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
   *                          test_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of test.
   *                          scorings:
   *                            type: object
   *                            description: Dictionary of test scores.
   *                          scenario_scorings:
   *                            type: array
   *                            items:
   *                              type: object
   *                              properties:
   *                                scenario_id:
   *                                 type: string
   *                                 format: uuid
   *                                 description: ID of scenario.
   *                                scorings:
   *                                  type: object
   *                                  description: Dictionary of scores.
   */
  getTestResults: GetHandler<'/results/submission/:submission_id/tests/:test_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id
    const testId = req.params.test_id
    const testScored = await this.aggregateTestScore(submissionId, testId)
    // transform for transmission
    // TODO: properly define data format of results for transmission
    const result = {
      test_id: testScored.definition.id,
      scorings: testScored.scorings,
      scenario_scorings: testScored.scenarios.map((scenario) => {
        return {
          scenario_id: scenario.definition.id,
          scorings: scenario.scorings,
        }
      }),
    }
    this.respond(res, result as json)
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
   *        description: Test ID.
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
   *                      description: ID of scenario
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

  /**
   * @swagger
   * /results/submission/{submission_id}/tests/{test_id}/scenario/{scenario_id}:
   *  get:
   *    description: Get submission results for specific scenario.
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
   *      - in: path
   *        name: scenario_id
   *        description: Scenario ID.
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *    responses:
   *      200:
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
   *                          scenario_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of scenario.
   *                          scorings:
   *                            type: object
   *                            description: Dictionary of scores.
   */
  getScenarioResults: GetHandler<'/results/submission/:submission_id/tests/:test_id/scenario/:scenario_id'> = async (
    req,
    res,
  ) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id
    const testId = req.params.test_id
    const scenarioId = req.params.scenario_id
    const scenarioScored = await this.aggregateScenarioScore(submissionId, testId, scenarioId)
    // transform for transmission
    // TODO: properly define data format of results for transmission
    const result = {
      scenario_id: scenarioScored.definition.id,
      scorings: scenarioScored.scorings,
    }
    this.respond(res, result as json)
  }

  // TODO: generalize the below:

  async aggregateScenarioScore(submissionId: string, testId: string, scenarioId: string) {
    const sql = SqlService.getInstance()
    // load required definitions
    const [scenarioDefRow] = await sql.query<ScenarioDefinitionRow>`
      SELECT * FROM scenario_definitions WHERE id=${scenarioId}
    `
    // load required candidates for referenced fields (used in upcast) and upcast
    const fieldDefCandidates = await sql.query<FieldDefinitionRow>`
      SELECT * FROM field_definitions
    `
    const scenarioDef = upcastScenarioDefinitionRow(scenarioDefRow, fieldDefCandidates)
    // load results
    const resultRows: ResultRow[] = await sql.query<ResultRow>`
      SELECT * FROM results WHERE submission_id=${submissionId} AND test_definition_id=${testId} AND scenario_definition_id=${scenarioId}
    `
    return Aggregator.getScenarioScored(scenarioDef, resultRows)
  }

  async aggregateTestScore(submissionId: string, testId: string) {
    const sql = SqlService.getInstance()
    // load required definitions
    const [testDefRow] = await sql.query<TestDefinitionRow>`
      SELECT * FROM test_definitions WHERE id=${testId}
    `
    // load required candidates for referenced fields (used in upcast) and upcast
    const fieldDefCandidates = await sql.query<FieldDefinitionRow>`
      SELECT * FROM field_definitions
    `
    const scenarioDefCandidates = await sql.query<ScenarioDefinitionRow>`
      SELECT * FROM scenario_definitions
    `
    const testDef = upcastTestDefinitionRow(testDefRow, fieldDefCandidates, scenarioDefCandidates)
    // load results
    const resultRows: ResultRow[] = await sql.query<ResultRow>`
      SELECT * FROM results WHERE submission_id=${submissionId} AND test_definition_id=${testId}
    `
    return Aggregator.getTestScored(testDef, resultRows)
  }
}
