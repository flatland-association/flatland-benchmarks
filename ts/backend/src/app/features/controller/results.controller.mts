import {
  BenchmarkDefinitionRow,
  CampaignItem,
  FieldDefinitionRow,
  Leaderboard,
  LeaderboardItem,
  ResultRow,
  ScenarioDefinitionRow,
  ScenarioScored,
  SubmissionRow,
  TestDefinitionRow,
  TestScored,
} from '@common/interfaces'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import {
  Aggregator,
  upcastBenchmarkDefinitionRow,
  upcastScenarioDefinitionRow,
  upcastSubmissionRow,
  upcastTestDefinitionRow,
} from '../utils/aggregator.mjs'
import { Controller, GetHandler, PostHandler } from './controller.mjs'

const logger = new Logger('results-controller')

export class ResultsController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/results/submissions/:submission_id', this.getSubmissionResults)
    this.attachGet('/results/submissions/:submission_id/tests/:test_id', this.getTestResults)
    this.attachPost('/results/submissions/:submission_id/tests/:test_id', this.postTestResults)
    this.attachGet('/results/submissions/:submission_id/tests/:test_id/scenario/:scenario_id', this.getScenarioResults)
    this.attachGet('/results/benchmarks/:benchmark_id', this.getLeaderboard)
    this.attachGet('/results/campaign-items/:benchmark_id', this.getCampaignItem)
    this.attachGet('/results/benchmarks/:benchmark_id/tests/:test_id', this.getTestLeaderboard)
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}:
   *  get:
   *    description: Get aggregated submission overall results.
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
   *    responses:
   *      200:
   *        description: Aggregated submission overall results.
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
   *                          submission_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of submission.
   *                          scorings:
   *                            type: object
   *                            description: Dictionary of submission scores.
   *                          test_scorings:
   *                            type: array
   *                            items:
   *                              type: object
   *                              properties:
   *                                test_id:
   *                                  type: string
   *                                  format: uuid
   *                                  description: ID of test.
   *                                scorings:
   *                                  type: object
   *                                  description: Dictionary of test scores.
   *                                scenario_scorings:
   *                                  type: array
   *                                  items:
   *                                    type: object
   *                                    properties:
   *                                      scenario_id:
   *                                        type: string
   *                                        format: uuid
   *                                        description: ID of scenario.
   *                                      scorings:
   *                                        type: object
   *                                        description: Dictionary of scores.
   */
  getSubmissionResults: GetHandler<'/results/submissions/:submission_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id
    const submissionScored = await this.aggregateSubmissionScore(submissionId)
    if (!submissionScored) {
      this.requestError(req, res, { text: 'Score could not be aggregated' })
      return
    }
    // transform for transmission
    // TODO: properly define data format of results for transmission
    const result: LeaderboardItem = {
      submission_id: submissionScored.submission.id,
      scorings: submissionScored.scorings,
      test_scorings: submissionScored.tests.map((test) => {
        return {
          test_id: test.definition.id,
          scorings: test.scorings,
          scenario_scorings: test.scenarios.map((scenario) => {
            return {
              scenario_id: scenario.definition.id,
              scorings: scenario.scorings,
            }
          }),
        }
      }),
    }
    this.respond(req, res, [result])
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}/tests/{test_id}:
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
   *        description: Submission results aggregated by test.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: object
   *                      properties:
   *                        test_id:
   *                          type: string
   *                          format: uuid
   *                          description: ID of test.
   *                        scorings:
   *                          type: object
   *                          description: Dictionary of test scores.
   *                        scenario_scorings:
   *                          type: array
   *                          items:
   *                            type: object
   *                            properties:
   *                              scenario_id:
   *                               type: string
   *                               format: uuid
   *                               description: ID of scenario.
   *                              scorings:
   *                                type: object
   *                                description: Dictionary of scores.
   */
  getTestResults: GetHandler<'/results/submissions/:submission_id/tests/:test_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id
    const testId = req.params.test_id
    const testScored = await this.aggregateTestScore(submissionId, testId)
    // transform for transmission
    // TODO: properly define data format of results for transmission
    const result: TestScored = {
      test_id: testScored.definition.id,
      scorings: testScored.scorings,
      scenario_scorings: testScored.scenarios.map((scenario) => {
        return {
          scenario_id: scenario.definition.id,
          scorings: scenario.scorings,
        }
      }),
    }
    this.respond(req, res, result)
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}/tests/{test_id}:
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
   *      201:
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
  postTestResults: PostHandler<'/results/submissions/:submission_id/tests/:test_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
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
      this.respond(req, res, {}, 201)
    } else {
      this.requestError(req, res, { text: 'Some results could not be inserted, transaction aborted.' })
    }
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}/tests/{test_id}/scenario/{scenario_id}:
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
   *        description: Submission results for specific scenario.
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
  getScenarioResults: GetHandler<'/results/submissions/:submission_id/tests/:test_id/scenario/:scenario_id'> = async (
    req,
    res,
  ) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id
    const testId = req.params.test_id
    const scenarioId = req.params.scenario_id
    const scenarioScored = await this.aggregateScenarioScore(submissionId, testId, scenarioId)
    // transform for transmission
    // TODO: properly define data format of results for transmission
    const result: ScenarioScored = {
      scenario_id: scenarioScored.definition.id,
      scorings: scenarioScored.scorings,
    }
    this.respond(req, res, [result])
  }

  /**
   * @swagger
   * /results/benchmarks/{benchmark_id}:
   *  get:
   *    description: Get benchmark leaderboard.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: benchmark_id
   *        description: Benchmark ID.
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *    responses:
   *      200:
   *        description: Benchmark leaderboard.
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
   *                          benchmark_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of benchmark.
   *                          items:
   *                            type: array
   *                            items:
   *                              type: object
   *                              properties:
   *                                submission_id:
   *                                  type: string
   *                                  format: uuid
   *                                  description: ID of submission.
   *                                scorings:
   *                                  type: object
   *                                  description: Dictionary of submission scores.
   *                                test_scorings:
   *                                  type: array
   *                                  items:
   *                                    type: object
   *                                    properties:
   *                                      test_id:
   *                                        type: string
   *                                        format: uuid
   *                                        description: ID of test.
   *                                      scorings:
   *                                        type: object
   *                                        description: Dictionary of test scores.
   *                                      scenario_scorings:
   *                                        type: array
   *                                        items:
   *                                          type: object
   *                                          properties:
   *                                            scenario_id:
   *                                              type: string
   *                                              format: uuid
   *                                              description: ID of scenario.
   *                                            scorings:
   *                                              type: object
   *                                              description: Dictionary of scores.
   */
  getLeaderboard: GetHandler<'/results/benchmarks/:benchmark_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const benchmarkId = req.params.benchmark_id
    const leaderboard = await this.aggregateLeaderboard(benchmarkId)
    if (!leaderboard) {
      this.requestError(req, res, { text: 'Leaderboard could not be aggregated' })
      return
    }
    // transform for transmission
    // TODO: properly define data format of results for transmission
    const result: Leaderboard = {
      benchmark_id: leaderboard.benchmark.id,
      items: leaderboard.items.map((item) => {
        return {
          submission_id: item.submission.id,
          scorings: item.scorings,
          test_scorings: item.tests.map((test) => {
            return {
              test_id: test.definition.id,
              scorings: test.scorings,
              scenario_scorings: test.scenarios.map((scenario) => {
                return {
                  scenario_id: scenario.definition.id,
                  scorings: scenario.scorings,
                }
              }),
            }
          }),
        }
      }),
    }
    this.respond(req, res, [result])
  }

  /**
   * @swagger
   * /results/campaign-items/{benchmark_id}:
   *  get:
   *    description: Get campaign item leaderboard.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: benchmark_id
   *        description: Benchmark ID.
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *    responses:
   *      200:
   *        description: Campaign item leaderboard.
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
   *                          benchmark_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of benchmark.
   *                          items:
   *                            type: array
   *                            items:
   *                              type: object
   *                              properties:
   *                                test_id:
   *                                  type: string
   *                                  format: uuid
   *                                  description: ID of test.
   *                                scorings:
   *                                  type: object
   *                                  description: Dictionary of test scores (best submission only).
   *                                submission_id:
   *                                  type: string
   *                                  format: uuid
   *                                  description: ID of best submission.
   */
  getCampaignItem: GetHandler<'/results/campaign-items/:benchmark_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const benchmarkId = req.params.benchmark_id
    const leaderboard = await this.aggregateCampaignItem(benchmarkId)
    if (!leaderboard) {
      this.requestError(req, res, { text: 'Campaign item could not be aggregated' })
      return
    }
    // transform for transmission
    // TODO: properly define data format of results for transmission
    const result: CampaignItem = {
      benchmark_id: benchmarkId,
      items: leaderboard.map((item) => {
        return {
          test_id: item.test.id,
          scorings: item.item?.scorings ?? null,
          submission_id: item.item?.submission.id ?? null,
        }
      }),
    }
    this.respond(req, res, [result])
  }

  /**
   * @swagger
   * /results/benchmarks/{benchmark_id}/tests/{test_id}:
   *  get:
   *    description: Get test leaderboard.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: benchmark_id
   *        description: Benchmark ID.
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
   *        description: test leaderboard.
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
   *                          benchmark_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of benchmark.
   *                          items:
   *                            type: array
   *                            items:
   *                              type: object
   *                              properties:
   *                                submission_id:
   *                                  type: string
   *                                  format: uuid
   *                                  description: ID of submission.
   *                                scorings:
   *                                  type: object
   *                                  description: Dictionary of submission scores.
   *                                test_scorings:
   *                                  type: array
   *                                  items:
   *                                    type: object
   *                                    properties:
   *                                      test_id:
   *                                        type: string
   *                                        format: uuid
   *                                        description: ID of test.
   *                                      scorings:
   *                                        type: object
   *                                        description: Dictionary of test scores.
   *                                      scenario_scorings:
   *                                        type: array
   *                                        items:
   *                                          type: object
   *                                          properties:
   *                                            scenario_id:
   *                                              type: string
   *                                              format: uuid
   *                                              description: ID of scenario.
   *                                            scorings:
   *                                              type: object
   *                                              description: Dictionary of scores.
   */
  getTestLeaderboard: GetHandler<'/results/benchmarks/:benchmark_id/tests/:test_id'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const benchmarkId = req.params.benchmark_id
    const testId = req.params.test_id
    // leaderboard contains all submissions (mixed tests), filter by test
    const leaderboard = await this.aggregateLeaderboard(benchmarkId)
    if (!leaderboard) {
      this.requestError(req, res, { text: 'Campaign item could not be aggregated' })
      return
    }
    // leaderboard contains all submissions (mixed tests), filter by test
    leaderboard.items = leaderboard.items.filter((item) => item.tests[0].definition.id === testId)
    // transform for transmission
    const result: Leaderboard = {
      benchmark_id: leaderboard.benchmark.id,
      items: leaderboard.items.map((item) => {
        return {
          submission_id: item.submission.id,
          scorings: item.scorings,
          test_scorings: item.tests.map((test) => {
            return {
              test_id: test.definition.id,
              scorings: test.scorings,
              scenario_scorings: test.scenarios.map((scenario) => {
                return {
                  scenario_id: scenario.definition.id,
                  scorings: scenario.scorings,
                }
              }),
            }
          }),
        }
      }),
    }
    this.respond(req, res, [result])
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

  async aggregateSubmissionScore(submissionId: string) {
    const sql = SqlService.getInstance()
    // load required definitions
    const [submissionRow] = await sql.query<SubmissionRow>`
      SELECT * FROM submissions WHERE id=${submissionId}
    `
    const [benchmarkDefRow] = await sql.query<BenchmarkDefinitionRow>`
      SELECT * FROM benchmark_definitions WHERE id=${submissionRow.benchmark_id}
    `
    // load required candidates for referenced fields (used in upcast) and upcast
    const fieldDefCandidates = await sql.query<FieldDefinitionRow>`
      SELECT * FROM field_definitions
    `
    const scenarioDefCandidates = await sql.query<ScenarioDefinitionRow>`
      SELECT * FROM scenario_definitions
    `
    const testDefCandidates = await sql.query<TestDefinitionRow>`
      SELECT * FROM test_definitions
    `
    const submission = upcastSubmissionRow(
      submissionRow,
      fieldDefCandidates,
      scenarioDefCandidates,
      testDefCandidates,
      [benchmarkDefRow],
    )
    // load results
    const resultRows: ResultRow[] = await sql.query<ResultRow>`
      SELECT * FROM results WHERE submission_id=${submissionId}
    `
    if (!submission.benchmark_definition) return null
    return Aggregator.getSubmissionScored(submission.benchmark_definition, submission, resultRows)
  }

  async aggregateLeaderboard(benchmarkId: string) {
    const sql = SqlService.getInstance()
    // load required definitions
    const submissionRows = await sql.query<SubmissionRow>`
      SELECT * FROM submissions WHERE benchmark_definition_id=${benchmarkId} AND published=true
    `
    const [benchmarkDefRow] = await sql.query<BenchmarkDefinitionRow>`
      SELECT * FROM benchmark_definitions WHERE id=${benchmarkId}
    `
    // load required candidates for referenced fields (used in upcast) and upcast
    const fieldDefCandidates = await sql.query<FieldDefinitionRow>`
      SELECT * FROM field_definitions
    `
    const scenarioDefCandidates = await sql.query<ScenarioDefinitionRow>`
      SELECT * FROM scenario_definitions
    `
    const testDefCandidates = await sql.query<TestDefinitionRow>`
      SELECT * FROM test_definitions
    `
    const submissions = submissionRows.map((submissionRow) =>
      upcastSubmissionRow(submissionRow, fieldDefCandidates, scenarioDefCandidates, testDefCandidates, [
        benchmarkDefRow,
      ]),
    )
    // load results
    const resultRows: ResultRow[] = await sql.query<ResultRow>`
      SELECT results.* FROM results LEFT JOIN submissions ON results.submission_id = submissions.id WHERE submissions.benchmark_definition_id=${benchmarkId}
    `
    const benchmarkDef = submissions.at(0)?.benchmark_definition
    if (!benchmarkDef) return null
    return Aggregator.getLeaderboard(benchmarkDef, submissions, resultRows)
  }

  async aggregateCampaignItem(benchmarkId: string) {
    const sql = SqlService.getInstance()
    // load required definitions
    const submissionRows = await sql.query<SubmissionRow>`
      SELECT * FROM submissions WHERE benchmark_definition_id=${benchmarkId} AND published=true
    `
    const [benchmarkDefRow] = await sql.query<BenchmarkDefinitionRow>`
      SELECT * FROM benchmark_definitions WHERE id=${benchmarkId}
    `
    // load required candidates for referenced fields (used in upcast) and upcast
    const fieldDefCandidates = await sql.query<FieldDefinitionRow>`
      SELECT * FROM field_definitions
    `
    const scenarioDefCandidates = await sql.query<ScenarioDefinitionRow>`
      SELECT * FROM scenario_definitions
    `
    const testDefCandidates = await sql.query<TestDefinitionRow>`
      SELECT * FROM test_definitions
    `
    // It's necessary to upcast both separately (potentially doing the work
    // twice), because getCampaignItemScored should return something even if
    // there's no submission to that benchmark yet.
    const benchmarkDef = upcastBenchmarkDefinitionRow(
      benchmarkDefRow,
      fieldDefCandidates,
      scenarioDefCandidates,
      testDefCandidates,
    )
    const submissions = submissionRows.map((submissionRow) =>
      upcastSubmissionRow(submissionRow, fieldDefCandidates, scenarioDefCandidates, testDefCandidates, [
        benchmarkDefRow,
      ]),
    )
    // load results
    const resultRows: ResultRow[] = await sql.query<ResultRow>`
      SELECT results.* FROM results LEFT JOIN submissions ON results.submission_id = submissions.id WHERE submissions.benchmark_definition_id=${benchmarkId}
    `
    if (!benchmarkDef) return null
    return Aggregator.getCampaignItemScored(benchmarkDef, submissions, resultRows)
  }
}
