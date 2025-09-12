import { ResultRow } from '@common/interfaces'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AggregatorService } from '../services/aggregator-service.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
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
    const submissionIds = req.params.submission_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const score = await aggregator.getSubmissionScore(submissionIds)
    this.respond(req, res, score)
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}/tests/{test_ids}:
   *  get:
   *    description: Get submission results aggregated by test.
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
    const submissionId = req.params.submission_id
    const testIds = req.params.test_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    // TOFIX: should return whole array
    // https://github.com/flatland-association/flatland-benchmarks/issues/352
    const [score] = await aggregator.getSubmissionTestScore(submissionId, testIds)
    this.respond(req, res, score)
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
    // see: https://github.com/flatland-association/flatland-benchmarks/issues/386
    // save in db
    const sql = SqlService.getInstance()
    try {
      await sql.transaction(async (sql) => {
        await sql.query`
          INSERT INTO results ${sql.fragment(resultRows)}
        `
      })
      this.respond(req, res, {}, undefined, 201)
    } catch (error) {
      logger.error(error)
      this.requestError(req, res, { text: 'Some results could not be inserted, transaction aborted.' })
    }
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}/scenario/{scenario_ids}:
   *  get:
   *    description: Get submission results for specific scenario.
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
    const submissionId = req.params.submission_id
    const scenarioIds = req.params.scenario_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const score = await aggregator.getSubmissionScenarioScore(submissionId, scenarioIds)
    this.respond(req, res, score)
  }

  /**
   * @swagger
   * /results/benchmarks/{benchmark_ids}:
   *  get:
   *    description: Get benchmark leaderboard.
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
    const benchmarkIds = req.params.benchmark_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getBenchmarkLeaderboard(benchmarkIds)
    this.respond(req, res, board)
  }

  /**
   * @swagger
   * /results/campaign-items/{benchmark_ids}:
   *  get:
   *    description: Returns campaign-item overviews (i.e. all tests in benchmark with score of top submission per test).
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
    const benchmarkIds = req.params.benchmark_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getCampaignItemOverview(benchmarkIds)
    this.respond(req, res, board)
  }

  /**
   * @swagger
   * /results/campaigns/{group_ids}:
   *  get:
   *    description: Returns campaign overviews (i.e. all benchmarks in the group with score aggregated from their top submission per test).
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
    const groupIds = req.params.group_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getCampaignOverview(groupIds)
    this.respond(req, res, board)
  }

  /**
   * @swagger
   * /results/benchmarks/{benchmark_id}/tests/{test_ids}:
   *  get:
   *    description: Get test leaderboard.
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
    const benchmarkId = req.params.benchmark_id
    const testIds = req.params.test_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getBenchmarkTestLeaderboard(benchmarkId, testIds)
    this.respond(req, res, board)
  }
}
