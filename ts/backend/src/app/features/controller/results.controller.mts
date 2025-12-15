import { ResultRow, SuiteSetup } from '@common/interfaces'
import { StripId } from '@common/utility-types'
import { StatusCodes } from 'http-status-codes'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AggregatorService } from '../services/aggregator-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { ControllerError } from './controller-utils.mjs'
import { Controller, GetHandler, PostHandler } from './controller.mjs'

const logger = new Logger('results-controller')

export class ResultsController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/results/submissions/:submission_ids', this.getSubmissionResults)
    this.attachGet('/results/submissions/:submission_id/tests/:test_ids', this.getTestResults)
    this.attachPost('/results/submissions/:submission_id/tests/:test_ids', this.postTestResults, {
      authorizedRoles: ['User'],
    })
    this.attachGet('/results/submissions/:submission_id/scenarios/:scenario_ids', this.getScenarioResults)
    this.attachGet('/results/benchmarks/:benchmark_ids', this.getLeaderboard)
    this.attachGet('/results/campaign-items/:benchmark_ids', this.getCampaignItemOverview)
    this.attachGet('/results/campaigns/:suite_ids', this.getCampaignOverview)
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
   *                            type: array
   *                            description: Submission scores.
   *                            items:
   *                              $ref: "#/components/schemas/Scoring"
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
   *                                  type: array
   *                                  description: Test scores.
   *                                  items:
   *                                    $ref: "#/components/schemas/Scoring"
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
   *                                        type: array
   *                                        description: Scenario scores.
   *                                        items:
   *                                          $ref: "#/components/schemas/Scoring"
   */
  getSubmissionResults: GetHandler<'/results/submissions/:submission_ids'> = async (req, res) => {
    const submissionIds = req.params.submission_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const score = await aggregator.getSubmissionScore(submissionIds)

    // filter child scores in COMPETITION
    const sql = SqlService.getInstance()
    const setups = await sql.query<{ id: string; setup: SuiteSetup }>`
      SELECT submissions.id, suites.setup
      FROM submissions
      LEFT JOIN benchmarks ON benchmarks.id = submissions.benchmark_id
      LEFT JOIN suites ON benchmarks.id = ANY(suites.benchmark_ids)
      WHERE submissions.id = ANY(${submissionIds})
    `
    score.forEach((submissionScore) => {
      const setup = setups.find((s) => s.id === submissionScore.submission_id)
      if (setup?.setup != 'DEFAULT' && setup?.setup != 'CAMPAIGN') {
        submissionScore.test_scorings = []
      }
    })

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
   *                      type: array
   *                      items:
   *                        type: object
   *                        properties:
   *                          test_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of test.
   *                          scorings:
   *                            type: array
   *                            description: Test scores.
   *                            items:
   *                              $ref: "#/components/schemas/Scoring"
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
   *                                  type: array
   *                                  description: Scenario scores.
   *                                  items:
   *                                    $ref: "#/components/schemas/Scoring"
   */
  getTestResults: GetHandler<'/results/submissions/:submission_id/tests/:test_ids'> = async (req, res) => {
    const submissionId = req.params.submission_id
    const testIds = req.params.test_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const score = await aggregator.getSubmissionTestScore(submissionId, testIds)

    // filter child scores in COMPETITION
    const sql = SqlService.getInstance()
    const setups = await sql.query<{ id: string; setup: SuiteSetup }>`
      SELECT tests.id, suites.setup
      FROM tests
      LEFT JOIN benchmarks ON tests.id = ANY(benchmarks.test_ids)
      LEFT JOIN suites ON benchmarks.id = ANY(suites.benchmark_ids)
      WHERE tests.id = ANY(${testIds})
    `
    score.forEach((submissionTestScore) => {
      const setup = setups.find((s) => s.id === submissionTestScore.test_id)
      if (setup?.setup != 'DEFAULT' && setup?.setup != 'CAMPAIGN') {
        submissionTestScore.scenario_scorings = []
      }
    })

    this.respondAfterPresenceCheck(req, res, score, testIds, 'test_id')
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
   *        description: Test ID.
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
   *                    scores:
   *                      type: object
   *                      additionalProperties:
   *                        type: number
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
    const submissionId = req.params.submission_id
    const testId = req.params.test_ids
    const resultRows = req.body.data.flatMap((score) => {
      const resultRows: ResultRow[] = []
      // the keys in score correspond to the key used in results table
      for (const key in score.scores) {
        resultRows.push({
          scenario_id: score.scenario_id,
          test_id: testId,
          submission_id: submissionId,
          key,
          value: score.scores[key],
        })
      }
      return resultRows
    })
    await this.checkValidity(resultRows)
    // save in db
    const sql = SqlService.getInstance()
    try {
      await sql.transaction(async (sql) => {
        await sql.query`
          INSERT INTO results ${sql.fragment(resultRows)}
        `
      })
      this.respond(req, res, {}, undefined, StatusCodes.CREATED)
    } catch (error) {
      logger.error(error)
      this.respondError(
        req,
        res,
        { text: 'Some results could not be inserted, transaction aborted.' },
        undefined,
        undefined,
        StatusCodes.CONFLICT,
      )
      logger.error(`${error} req.body.data=${req.body.data}`)
      logger.error(`${error} req.body=${req.body}`)
      logger.error(`${error} sql.notices=${sql.notices}`)
      logger.error(`${error} sql.statements=${sql.statements}`)
    }
  }

  /**
   * @swagger
   * /results/submissions/{submission_id}/scenarios/{scenario_ids}:
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
   *                            type: array
   *                            description: Scenario scores.
   *                            items:
   *                              $ref: "#/components/schemas/Scoring"
   */
  getScenarioResults: GetHandler<'/results/submissions/:submission_id/scenarios/:scenario_ids'> = async (req, res) => {
    const submissionId = req.params.submission_id
    const scenarioIds = req.params.scenario_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const score = await aggregator.getSubmissionScenarioScore(submissionId, scenarioIds)
    this.respondAfterPresenceCheck(req, res, score, scenarioIds, 'scenario_id')
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
   *                                  type: array
   *                                  description: Submission scores.
   *                                  items:
   *                                    $ref: "#/components/schemas/Scoring"
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
   *                                        type: array
   *                                        description: Test scores.
   *                                        items:
   *                                          $ref: "#/components/schemas/Scoring"
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
   *                                              type: array
   *                                              description: Scenario scores.
   *                                              items:
   *                                                $ref: "#/components/schemas/Scoring"
   */
  getLeaderboard: GetHandler<'/results/benchmarks/:benchmark_ids'> = async (req, res) => {
    const benchmarkIds = req.params.benchmark_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getBenchmarkLeaderboard(benchmarkIds)

    // filter child scores in COMPETITION
    const sql = SqlService.getInstance()
    const setups = await sql.query<{ id: string; setup: SuiteSetup }>`
      SELECT benchmarks.id, suites.setup
      FROM benchmarks
      LEFT JOIN suites ON benchmarks.id = ANY(suites.benchmark_ids)
      WHERE benchmarks.id = ANY(${benchmarkIds})
    `
    board.forEach((leaderboard) => {
      const setup = setups.find((s) => s.id === leaderboard.benchmark_id)
      if (setup?.setup != 'DEFAULT' && setup?.setup != 'CAMPAIGN') {
        leaderboard.items.forEach((submissionScore) => {
          submissionScore.test_scorings = []
        })
      }
    })

    this.respondAfterPresenceCheck(req, res, board, benchmarkIds, 'benchmark_id')
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
   *                                  type: array
   *                                  description: Test scores (best submission only).
   *                                  items:
   *                                    $ref: "#/components/schemas/Scoring"
   *                                submission_id:
   *                                  type: string
   *                                  format: uuid
   *                                  description: ID of best submission.
   */
  getCampaignItemOverview: GetHandler<'/results/campaign-items/:benchmark_ids'> = async (req, res) => {
    const benchmarkIds = req.params.benchmark_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getCampaignItemOverview(benchmarkIds)
    this.respondAfterPresenceCheck(req, res, board, benchmarkIds, 'benchmark_id')
  }

  /**
   * @swagger
   * /results/campaigns/{suite_ids}:
   *  get:
   *    description: Returns campaign overviews (i.e. all benchmarks in the suite with score aggregated from their top submission per test).
   *    parameters:
   *      - in: path
   *        name: suite_ids
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
   *                          suite_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of suite.
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
   *                                        type: array
   *                                        description: Test scores (best submission only).
   *                                        items:
   *                                          $ref: "#/components/schemas/Scoring"
   *                                      submission_id:
   *                                        type: string
   *                                        format: uuid
   *                                        description: ID of best submission.
   *                                scorings:
   *                                  type: array
   *                                  description: Campaign item scores.
   *                                  items:
   *                                    $ref: "#/components/schemas/Scoring"
   */
  getCampaignOverview: GetHandler<'/results/campaigns/:suite_ids'> = async (req, res) => {
    const suiteIds = req.params.suite_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getCampaignOverview(suiteIds)
    this.respondAfterPresenceCheck(req, res, board, suiteIds, 'suite_id')
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
   *                          test_id:
   *                            type: string
   *                            format: uuid
   *                            description: ID of test.
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
   *                                  type: array
   *                                  description: Submission scores.
   *                                  items:
   *                                    $ref: "#/components/schemas/Scoring"
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
   *                                        type: array
   *                                        description: Test scores.
   *                                        items:
   *                                          $ref: "#/components/schemas/Scoring"
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
   *                                              type: array
   *                                              description: Scenario scores.
   *                                              items:
   *                                                $ref: "#/components/schemas/Scoring"
   */
  getTestLeaderboard: GetHandler<'/results/benchmarks/:benchmark_id/tests/:test_ids'> = async (req, res) => {
    const benchmarkId = req.params.benchmark_id
    const testIds = req.params.test_ids.split(',')

    const aggregator = AggregatorService.getInstance()
    const board = await aggregator.getBenchmarkTestLeaderboard(benchmarkId, testIds)

    // filter child scores in COMPETITION
    const sql = SqlService.getInstance()
    const setups = await sql.query<{ id: string; setup: SuiteSetup }>`
      SELECT tests.id, suites.setup
      FROM tests
      LEFT JOIN benchmarks ON tests.id = ANY(benchmarks.test_ids)
      LEFT JOIN suites ON benchmarks.id = ANY(suites.benchmark_ids)
      WHERE tests.id = ANY(${testIds})
    `
    board.forEach((leaderboard) => {
      const setup = setups.find((s) => s.id === leaderboard.test_id)
      if (setup?.setup != 'DEFAULT' && setup?.setup != 'CAMPAIGN') {
        leaderboard.items.forEach((submissionScore) => {
          submissionScore.test_scorings = []
        })
      }
    })

    this.respondAfterPresenceCheck(req, res, board, testIds, 'test_id')
  }

  // not using `validate` to keep the `checkX` pattern up
  /**
   * Checks if all values in the provided `resource` are valid.
   * @param resources Resources to validate.
   * @throws {ControllerError} When check failed.
   */
  async checkValidity(resources: StripId<ResultRow>[]) {
    const sql = SqlService.getInstance()
    // load sources (greedy, filter later on)
    // (derived via referenced submissions -> tests -> scenarios -> fields)
    const submissionIds = Array.from(new Set(resources.map((r) => r.submission_id)))
    const [sources] = await sql.query<{
      submissions: { id: string; test_ids: string[] }[] | null
      tests: { id: string; scenario_ids: string[] }[] | null
      scenarios: { id: string; field_ids: string[] }[] | null
      fields: { id: string; key: string }[] | null
    }>`
      SELECT
        json_agg(DISTINCT jsonb_build_object('id', submissions.id, 'test_ids', submissions.test_ids)) AS submissions,
        json_agg(DISTINCT jsonb_build_object('id', tests.id, 'scenario_ids', tests.scenario_ids)) AS tests,
        json_agg(DISTINCT jsonb_build_object('id', scenarios.id, 'field_ids', scenarios.field_ids)) AS scenarios,
        json_agg(DISTINCT jsonb_build_object('id', fields.id, 'key', fields.key)) AS fields
      FROM submissions
      LEFT JOIN tests ON tests.id = ANY(submissions.test_ids)
      LEFT JOIN scenarios ON scenarios.id = ANY(tests.scenario_ids)
      LEFT JOIN fields ON fields.id = ANY(scenarios.field_ids)
      WHERE submissions.id = ANY(${submissionIds})
    `
    logger.debug('loaded sources', sources)
    // for every resource, check the chain of references
    resources.forEach((resource) => {
      // submission from sources
      const submission = sources.submissions?.find((s) => s.id === resource.submission_id)
      if (!submission) {
        throw new ControllerError(
          'Referenced submission does not exist',
          { submission: resource.submission_id },
          StatusCodes.BAD_REQUEST,
        )
      }
      // test must be referenced by submission
      const referencedTests = sources.tests?.filter((t) => submission?.test_ids.includes(t.id))
      const test = referencedTests?.find((t) => t.id === resource.test_id)
      if (!test) {
        throw new ControllerError(
          'Referenced test is not available',
          { test: resource.test_id, submission: resource.submission_id },
          StatusCodes.BAD_REQUEST,
        )
      }
      // scenario must be referenced by test
      const referencedScenarios = sources.scenarios?.filter((s) => test?.scenario_ids.includes(s.id))
      const scenario = referencedScenarios?.find((s) => s.id === resource.scenario_id)
      if (!scenario) {
        throw new ControllerError(
          'Referenced scenario is not available',
          { scenario: resource.scenario_id, test: resource.test_id, submission: resource.submission_id },
          StatusCodes.BAD_REQUEST,
        )
      }
      // field must be referenced by scenario
      const referencedFields = sources.fields?.filter((f) => scenario?.field_ids.includes(f.id))
      const field = referencedFields?.find((f) => f.key === resource.key)
      // check key belongs to scenarios field definition
      if (!field) {
        throw new ControllerError(
          'Referenced field is not available',
          {
            field: resource.key,
            scenario: resource.scenario_id,
            test: resource.test_id,
            submission: resource.submission_id,
          },
          StatusCodes.BAD_REQUEST,
        )
      }
    })
  }
}
