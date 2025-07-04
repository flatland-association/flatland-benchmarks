import {
  BenchmarkDefinitionRow,
  BenchmarkGroupDefinitionRow,
  CampaignItemOverview,
  CampaignItemOverviewItem,
  CampaignOverview,
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
  upcastBenchmarkGroupDefinitionRow,
  upcastScenarioDefinitionRow,
  upcastSubmissionRow,
  upcastTestDefinitionRow,
} from '../utils/aggregator.mjs'
import { Controller, GetHandler, PostHandler } from './controller.mjs'

const logger = new Logger('results-controller')

export class ResultsController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/results/submissions/:submission_ids', this.getSubmissionResults)
    this.attachGet('/results/submissions/:submission_id/tests/:test_ids', this.getTestResults)
    this.attachPost('/results/submissions/:submission_id/tests/:test_ids', this.postTestResults)
    this.attachGet('/results/submissions/:submission_id/scenario/:scenario_ids', this.getScenarioResults)
    this.attachGet('/results/benchmarks/:benchmark_ids', this.getLeaderboard)
    this.attachGet('/results/campaign-items/:benchmark_ids', this.getCampaignItemOverview)
    this.attachGet('/results/campaigns/:group_ids', this.getCampaignOverview)
    this.attachGet('/results/benchmarks/:benchmark_id/tests/:test_ids', this.getTestLeaderboard)
  }

  /**
   * @swagger
   * /results/submissions/{submission_ids}:
   *  get:
   *    description: Get aggregated submission overall results.
   *    security:
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
  getSubmissionResults: GetHandler<'/results/submissions/:submission_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }

    const submissionIds = req.params.submission_ids.split(',')
    const leaderboardItems: LeaderboardItem[] = []
    for (const submissionId of submissionIds) {
      const leaderboardItem = await this.aggregateSubmissionScore(submissionId)
      // only transmit valid items
      if (leaderboardItem) {
        // transform for transmission
        leaderboardItems.push({
          submission_id: leaderboardItem.submission.id,
          scorings: leaderboardItem.scorings,
          test_scorings: leaderboardItem.tests.map((test) => {
            return {
              test_id: test.definition.id,
              scorings: test.scorings,
              scenario_scorings: test.scenarios.map((scenario) => {
                return {
                  scenario_id: scenario.definition.id,
                  scorings: scenario.scorings,
                } satisfies ScenarioScored
              }),
            } satisfies TestScored
          }),
        })
      }
    }
    this.respond(req, res, leaderboardItems)
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}/tests/{test_ids}:
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
   *        name: test_ids
   *        description: Comma-separated list of test IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
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
  getTestResults: GetHandler<'/results/submissions/:submission_id/tests/:test_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id

    // TODO https://github.com/flatland-association/flatland-benchmarks/issues/317 support multiple test_ids
    const testId = req.params.test_ids
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
   * /results/submissions/{submission_id}/tests/{test_ids}:
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
   *        name: test_ids
   *        description: Comma-separated list of test IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
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
  postTestResults: PostHandler<'/results/submissions/:submission_id/tests/:test_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id

    // TODO https://github.com/flatland-association/flatland-benchmarks/issues/317 support multiple test_ids
    const testId = req.params.test_ids
    const resultRows = req.body.data.flatMap((score) => {
      const resultRows: ResultRow[] = []
      // score's keys are keys of score, except for the one being scenario_id, which is scenario_id
      for (const key in score) {
        if (key != 'scenario_id') {
          resultRows.push({
            scenario_id: score.scenario_id,
            test_id: testId,
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
   * /results/submissions/{submission_id}/scenario/{scenario_ids}:
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
   *        name: scenario_ids
   *        description: Comma-separated list of scenario IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
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
  getScenarioResults: GetHandler<'/results/submissions/:submission_id/scenario/:scenario_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const submissionId = req.params.submission_id

    // TODO https://github.com/flatland-association/flatland-benchmarks/issues/317 support multiple scenario_ids
    const scenarioId = req.params.scenario_ids
    const scenarioScored = await this.aggregateScenarioScore(submissionId, scenarioId)
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
   * /results/benchmarks/{benchmark_ids}:
   *  get:
   *    description: Get benchmark leaderboard.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: benchmark_ids
   *        description: Comma-separated list of benchmark IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
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
  getLeaderboard: GetHandler<'/results/benchmarks/:benchmark_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }

    // TODO https://github.com/flatland-association/flatland-benchmarks/issues/317 support multiple benchmark_ids
    const benchmarkId = req.params.benchmark_ids
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
   * /results/campaign-items/{benchmark_ids}:
   *  get:
   *    description: Returns campaign-item overviews (i.e. all tests in benchmark with score of top submission per test).
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: benchmark_ids
   *        description: Comma-separated list of benchmark IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
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
  getCampaignItemOverview: GetHandler<'/results/campaign-items/:benchmark_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const benchmarkIds = req.params.benchmark_ids.split(',')
    const itemOverviews: CampaignItemOverview[] = []
    for (const benchmarkId of benchmarkIds) {
      const leaderboard = await this.aggregateCampaignItem(benchmarkId)
      // only transmit valid overviews
      if (leaderboard) {
        // transform for transmission
        // TODO: properly define data format of results for transmission
        itemOverviews.push({
          benchmark_id: benchmarkId,
          items: leaderboard.items.map((item) => {
            return {
              test_id: item.test.id,
              scorings: item.scorings ?? null,
              submission_id: item.submission?.id ?? null,
            }
          }),
          scorings: leaderboard.scorings,
        })
      }
    }
    this.respond(req, res, itemOverviews)
  }

  /**
   * @swagger
   * /results/campaigns/{group_ids}:
   *  get:
   *    description: Returns campaign overviews (i.e. all benchmarks in the group with score aggregated from their top submission per test).
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: group_ids
   *        description: Comma-separated list of IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *    responses:
   *      200:
   *        description: Campaign leaderboard.
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
   *                          group_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of benchmark group.
   *                          items:
   *                            type: array
   *                            items:
   *                              type: object
   *                              properties:
   *                                benchmark_id:
   *                                  type: string
   *                                  format: uuid
   *                                  description: ID of benchmark.
   *                                items:
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
   *                                        description: Dictionary of test scores (best submission only).
   *                                      submission_id:
   *                                        type: string
   *                                        format: uuid
   *                                        description: ID of best submission.
   *                          scorings:
   *                            type: object
   *                            description: Dictionary of group scores
   */
  getCampaignOverview: GetHandler<'/results/campaigns/:group_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const groupIds = req.params.group_ids.split(',')
    const overviews: CampaignOverview[] = []
    for (const groupId of groupIds) {
      const leaderboard = await this.aggregateGroupLeaderboard(groupId)
      // only transmit valid overviews
      if (leaderboard) {
        // transform for transmission
        // TODO: properly define data format of results for transmission
        overviews.push({
          group_id: groupId,
          items: leaderboard.items.map((campaignItem) => {
            return {
              benchmark_id: campaignItem.benchmark.id,
              items: campaignItem.items.map((campaignItemItem) => {
                return {
                  test_id: campaignItemItem.test.id,
                  scorings: campaignItemItem.scorings,
                  submission_id: campaignItemItem.submission?.id ?? null,
                } satisfies CampaignItemOverviewItem
              }),
              scorings: campaignItem.scorings,
            } satisfies CampaignItemOverview
          }),
        })
      }
    }
    this.respond(req, res, overviews)
  }

  /**
   * @swagger
   * /results/benchmarks/{benchmark_id}/tests/{test_ids}:
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
   *        name: test_ids
   *        description: Comma-separated list of test IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
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
  getTestLeaderboard: GetHandler<'/results/benchmarks/:benchmark_id/tests/:test_ids'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(req, res, { text: 'Not authorized' })
      return
    }
    const benchmarkId = req.params.benchmark_id

    // TODO https://github.com/flatland-association/flatland-benchmarks/issues/317 support multiple test_ids
    const testId = req.params.test_ids
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

  async aggregateScenarioScore(submissionId: string, scenarioId: string) {
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
      SELECT * FROM results WHERE submission_id=${submissionId} AND scenario_id=${scenarioId}
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
      SELECT * FROM results WHERE submission_id=${submissionId} AND test_id=${testId}
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
      SELECT * FROM submissions WHERE benchmark_id=${benchmarkId} AND published=true
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
      SELECT results.* FROM results LEFT JOIN submissions ON results.submission_id = submissions.id WHERE submissions.benchmark_id=${benchmarkId}
    `
    const benchmarkDef = submissions.at(0)?.benchmark_definition
    if (!benchmarkDef) return null
    return Aggregator.getLeaderboard(benchmarkDef, submissions, resultRows)
  }

  async aggregateCampaignItem(benchmarkId: string) {
    const sql = SqlService.getInstance()
    // load required definitions
    const submissionRows = await sql.query<SubmissionRow>`
      SELECT * FROM submissions WHERE benchmark_id=${benchmarkId} AND published=true
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
      SELECT results.* FROM results LEFT JOIN submissions ON results.submission_id = submissions.id WHERE submissions.benchmark_id=${benchmarkId}
    `
    if (!benchmarkDef) return null
    return Aggregator.getCampaignItemScored(benchmarkDef, submissions, resultRows)
  }

  async aggregateGroupLeaderboard(groupId: string) {
    const sql = SqlService.getInstance()
    // load required definitions
    const [groupDefRow] = await sql.query<BenchmarkGroupDefinitionRow>`
      SELECT * FROM benchmark_groups WHERE id=${groupId}
    `
    const submissionRows = await sql.query<SubmissionRow>`
      SELECT * FROM submissions WHERE benchmark_id=ANY(${groupDefRow.benchmark_ids}) AND published=true
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
    const benchmarkDefCandidates = await sql.query<BenchmarkDefinitionRow>`
      SELECT * FROM benchmark_definitions WHERE id=ANY(${groupDefRow.benchmark_ids})
    `
    // It's necessary to upcast both separately (potentially doing the work
    // twice), because getGroupLeaderboard should return something even if
    // there's no submission to a group or therein benchmark yet.
    const groupDef = upcastBenchmarkGroupDefinitionRow(
      groupDefRow,
      benchmarkDefCandidates,
      fieldDefCandidates,
      scenarioDefCandidates,
      testDefCandidates,
    )
    const submissions = submissionRows.map((submissionRow) =>
      upcastSubmissionRow(
        submissionRow,
        fieldDefCandidates,
        scenarioDefCandidates,
        testDefCandidates,
        benchmarkDefCandidates,
      ),
    )
    // load results
    const resultRows: ResultRow[] = await sql.query<ResultRow>`
      SELECT results.* FROM results LEFT JOIN submissions ON results.submission_id = submissions.id WHERE submissions.benchmark_id=ANY(${groupDefRow.benchmark_ids})
    `
    if (!groupDef) return null
    return Aggregator.getGroupLeaderboard(groupDef, submissions, resultRows)
  }
}
