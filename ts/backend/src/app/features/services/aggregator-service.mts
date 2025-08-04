import {
  BenchmarkDefinitionRow,
  BenchmarkGroupDefinitionRow,
  CampaignItemOverview,
  CampaignOverview,
  FieldDefinitionRow,
  Leaderboard,
  ResultRow,
  ScenarioDefinitionRow,
  Scoring,
  Scorings,
  SubmissionRow,
  SubmissionScenarioScore,
  SubmissionScore,
  SubmissionTestScore,
  TestDefinitionRow,
} from '@common/interfaces'
import { json } from '@common/utility-types'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { Service } from './service.mjs'
import { SqlService } from './sql-service.mjs'

const logger = new Logger('aggregator-service')

// the models are aggregated to arrays in SQL query:
interface SubmissionScenarioScoreSources {
  scenario_definitions: (ScenarioDefinitionRow | null)[]
  field_definitions: (FieldDefinitionRow | null)[]
  results: (ResultRow | null)[]
}

interface SubmissionTestScoreSources extends SubmissionScenarioScoreSources {
  test_definitions: (TestDefinitionRow | null)[]
}

interface SubmissionScoreSources extends SubmissionTestScoreSources {
  submissions: (SubmissionRow | null)[]
  // benchmark_definitions required as well, because the field definitions for
  // submission score aggregation are stored in there.
  benchmark_definitions: (BenchmarkDefinitionRow | null)[]
}

interface CampaignOverviewSources extends SubmissionScoreSources {
  benchmark_groups: (BenchmarkGroupDefinitionRow | null)[]
}

/**
 * This service can calculate scores, provide leaderboards and overviews for
 * different entities.
 *
 * It basically works in three stages:
 * 1. Load required sources:\
 *    Necessary definitions as well as submissions and results are loaded from
 *    database. Only required data is loaded, depending on the entity being
 *    scored.
 * 2. Calculate score:\
 *    The loaded results are applied to matching scenarios and aggregated up the
 *    tree (scenario > test > submission > benchmark) to the requested level.
 * 3. Process entities (optional):\
 *    If requested, once all entities are scored, the scored entities can be
 *    processed, i.e. ranked and sorted for leaderboards or filtered by top
 *    score for overviews.
 */
export class AggregatorService extends Service {
  constructor(config: configuration) {
    super(config)
  }

  // Public interface

  /**
   * Returns `SubmissionScenarioScore` for one or more scenarios of specified
   * submission (submission does not need to be published).
   */
  async getSubmissionScenarioScore(submissionId: string, scenarioIds: string[]): Promise<SubmissionScenarioScore[]> {
    logger.trace('getSubmissionScenarioScore', { submissionId, scenarioIds })
    // load relevant sources
    const sources = await this.loadSubmissionScenarioScoreSources(submissionId, scenarioIds)
    // aggregate for all scenarios
    return scenarioIds.map((scenarioId) => this.calculateSubmissionScenarioScore(sources, submissionId, scenarioId))
  }

  /**
   * Returns `SubmissionTestScore` for one or more tests of specified submission
   * (submission does not need to be published).
   */
  async getSubmissionTestScore(submissionId: string, testIds: string[]): Promise<SubmissionTestScore[]> {
    logger.trace('getSubmissionTestScore', { submissionId, testIds })
    // load relevant sources
    const sources = await this.loadSubmissionTestScoreSources(submissionId, testIds)
    // aggregate for all tests
    return testIds.map((testId) => this.calculateSubmissionTestScore(sources, submissionId, testId))
  }

  /**
   * Returns `SubmissionScore` for one or more specified submissions
   * (submissions do not need to be published).
   */
  async getSubmissionScore(submissionIds: string[]): Promise<SubmissionScore[]> {
    logger.trace('getSubmissionScore', { submissionIds })
    // load relevant sources
    const sources = await this.loadSubmissionScoreSources(submissionIds)
    // aggregate for all submissions
    return submissionIds.map((submissionId) => this.calculateSubmissionScore(sources, submissionId))
  }

  /**
   * Returns `Leaderboard` for one or more tests of specified benchmark.
   * Only published submissions are included in leaderboard.
   */
  async getBenchmarkTestLeaderboard(benchmarkId: string, testIds: string[]): Promise<Leaderboard[]> {
    logger.trace('getBenchmarkTestLeaderboard', { benchmarkId, testIds })
    // load relevant sources
    const sources = await this.loadLeaderboardSources([benchmarkId])
    // build leaderboard for whole benchmark,...
    const board = this.buildLeaderboard(sources, benchmarkId)
    //... triage/filter by test and sort by primary test score
    return testIds.map((testId) => {
      const leaderboard: Leaderboard = {
        benchmark_id: benchmarkId,
        items: board.items.filter((item) => item.test_scorings.some((score) => score.test_id === testId)),
      }
      // sort leaderboard items by primary test score
      const test = this.findTest(sources, testId)
      if (test) {
        const primary = this.findPrimaryField(sources, test)
        if (primary) {
          leaderboard.items.sort((a, b) => {
            const testA = a.test_scorings.find((score) => score.test_id === testId)!
            const testB = b.test_scorings.find((score) => score.test_id === testId)!
            const rankA = testA.scorings[primary.key]?.rank ?? Number.POSITIVE_INFINITY
            const rankB = testB.scorings[primary.key]?.rank ?? Number.POSITIVE_INFINITY
            return rankA - rankB
          })
        }
      }
      return leaderboard
    })
  }

  /**
   * Returns `Leaderboard` for one or more specified benchmarks.
   * Only published submissions are included in leaderboard.
   */
  async getBenchmarkLeaderboard(benchmarkIds: string[]): Promise<Leaderboard[]> {
    logger.trace('getBenchmarkLeaderboard', { benchmarkIds })
    // load relevant sources
    const sources = await this.loadLeaderboardSources(benchmarkIds)
    // build leaderboard for all benchmarks and sort by primary submission score
    return benchmarkIds.map((benchmarkId) => {
      const leaderboard = this.buildLeaderboard(sources, benchmarkId)
      // sort leaderboard items by primary submission score
      const benchmark = this.findBenchmark(sources, benchmarkId)
      if (benchmark) {
        const primary = this.findPrimaryField(sources, benchmark)
        if (primary) {
          leaderboard.items.sort((a, b) => {
            const rankA = a.scorings[primary.key]?.rank ?? Number.POSITIVE_INFINITY
            const rankB = b.scorings[primary.key]?.rank ?? Number.POSITIVE_INFINITY
            return rankA - rankB
          })
        }
      }
      return leaderboard
    })
  }

  /**
   * Returns `CampaignItemOverview` for one or more specified benchmarks.
   * Only published submissions are considered.
   */
  async getCampaignItemOverview(benchmarkIds: string[]): Promise<CampaignItemOverview[]> {
    logger.trace('getCampaignItemOverview', { benchmarkIds })
    // load relevant sources (campaign items are extracted via leaderboard)
    const sources = await this.loadLeaderboardSources(benchmarkIds)
    // build overview for all benchmarks
    return benchmarkIds.map((benchmarkId) => this.buildCampaignItemOverview(sources, benchmarkId))
  }

  /**
   * Returns `CampaignOverview` for one or more specified benchmark groups.
   * Only published submissions are considered.
   */
  async getCampaignOverview(groupIds: string[]): Promise<CampaignOverview[]> {
    logger.trace('getCampaignOverview', { groupIds })
    // load relevant sources
    const sources = await this.loadCampaignOverviewSources(groupIds)
    // build overview for all groups
    return groupIds.map((groupId) => this.buildCampaignOverview(sources, groupId))
  }

  // Source loading and lookup

  /**
   * Loads sources required to calculate `SubmissionScenarioScore`s.
   */
  async loadSubmissionScenarioScoreSources(
    submissionId: string,
    scenarioIds: string[],
  ): Promise<SubmissionScenarioScoreSources> {
    logger.trace('loadSubmissionScenarioScoreSources', { submissionId, scenarioIds })
    const sql = SqlService.getInstance()
    // load relevant sources (relevant means: referenced from scenarioId)
    const [sources] = await sql.query<SubmissionScenarioScoreSources>`
      SELECT
        json_agg(DISTINCT to_jsonb(scenario_definitions)) AS scenario_definitions,
        json_agg(DISTINCT to_jsonb(field_definitions)) AS field_definitions,
        json_agg(DISTINCT to_jsonb(results)) AS results
      FROM scenario_definitions
      LEFT JOIN field_definitions ON field_definitions.id = ANY(scenario_definitions.field_ids)
      LEFT JOIN results ON results.scenario_id = scenario_definitions.id AND results.submission_id = ${submissionId}
      WHERE scenario_definitions.id = ANY(${scenarioIds})
    `
    return sources
  }

  /**
   * Loads sources required to calculate `SubmissionTestScore`s.
   */
  async loadSubmissionTestScoreSources(submissionId: string, testIds: string[]): Promise<SubmissionTestScoreSources> {
    const sql = SqlService.getInstance()
    // load relevant sources (relevant means: referenced from testId)
    const [sources] = await sql.query<SubmissionTestScoreSources>`
      SELECT
        json_agg(DISTINCT to_jsonb(test_definitions)) AS test_definitions,
        json_agg(DISTINCT to_jsonb(scenario_definitions)) AS scenario_definitions,
        json_agg(DISTINCT to_jsonb(field_definitions)) AS field_definitions,
        json_agg(DISTINCT to_jsonb(results)) AS results
      FROM test_definitions
      LEFT JOIN scenario_definitions ON scenario_definitions.id = ANY(test_definitions.scenario_ids)
      LEFT JOIN field_definitions ON field_definitions.id = ANY(scenario_definitions.field_ids || test_definitions.field_ids)
      LEFT JOIN results ON results.scenario_id = scenario_definitions.id AND results.submission_id = ${submissionId}
      WHERE test_definitions.id = ANY(${testIds})
    `
    return sources
  }

  /**
   * Loads sources required to calculate `SubmissionScore`s.
   */
  async loadSubmissionScoreSources(submissionIds: string[]): Promise<SubmissionScoreSources> {
    const sql = SqlService.getInstance()
    // load relevant sources (relevant means: referenced from benchmark
    // submission was made for)
    // IMPORTANT: Do not shortcut to "reference tests from submission directly",
    // since submission might be for fewer tests than required by benchmark
    // definition for correct aggregation of submission score.
    const [sources] = await sql.query<SubmissionScoreSources>`
      SELECT
        json_agg(DISTINCT to_jsonb(submissions)) AS submissions,
        json_agg(DISTINCT to_jsonb(benchmark_definitions)) AS benchmark_definitions,
        json_agg(DISTINCT to_jsonb(test_definitions)) AS test_definitions,
        json_agg(DISTINCT to_jsonb(scenario_definitions)) AS scenario_definitions,
        json_agg(DISTINCT to_jsonb(field_definitions)) AS field_definitions,
        json_agg(DISTINCT to_jsonb(results)) AS results
      FROM submissions
      LEFT JOIN benchmark_definitions ON benchmark_definitions.id = submissions.benchmark_id
      LEFT JOIN test_definitions ON test_definitions.id = ANY(benchmark_definitions.test_ids)
      LEFT JOIN scenario_definitions ON scenario_definitions.id = ANY(test_definitions.scenario_ids)
      LEFT JOIN field_definitions ON field_definitions.id = ANY(scenario_definitions.field_ids || test_definitions.field_ids || benchmark_definitions.field_ids)
      LEFT JOIN results ON results.scenario_id = scenario_definitions.id AND results.submission_id = submissions.id
      WHERE submissions.id = ANY(${submissionIds})
    `
    return sources
  }

  /**
   * Loads sources required to build `Leaderboard`s.
   */
  async loadLeaderboardSources(benchmarkIds: string[]): Promise<SubmissionScoreSources> {
    const sql = SqlService.getInstance()
    // load relevant sources (relevant means: referenced from benchmark)
    const [sources] = await sql.query<SubmissionScoreSources>`
      SELECT
        json_agg(DISTINCT to_jsonb(benchmark_definitions)) AS benchmark_definitions,
        json_agg(DISTINCT to_jsonb(submissions)) AS submissions,
        json_agg(DISTINCT to_jsonb(test_definitions)) AS test_definitions,
        json_agg(DISTINCT to_jsonb(scenario_definitions)) AS scenario_definitions,
        json_agg(DISTINCT to_jsonb(field_definitions)) AS field_definitions,
        json_agg(DISTINCT to_jsonb(results)) AS results
      FROM benchmark_definitions
      LEFT JOIN submissions ON submissions.benchmark_id = benchmark_definitions.id AND submissions.published = true
      LEFT JOIN test_definitions ON test_definitions.id = ANY(benchmark_definitions.test_ids)
      LEFT JOIN scenario_definitions ON scenario_definitions.id = ANY(test_definitions.scenario_ids)
      LEFT JOIN field_definitions ON field_definitions.id = ANY(scenario_definitions.field_ids || test_definitions.field_ids || benchmark_definitions.field_ids)
      LEFT JOIN results ON results.scenario_id = scenario_definitions.id AND results.submission_id = submissions.id
      WHERE benchmark_definitions.id = ANY(${benchmarkIds})
    `
    return sources
  }

  /**
   * Loads sources required to build `CampaignOverview`s.
   */
  async loadCampaignOverviewSources(groupIds: string[]): Promise<CampaignOverviewSources> {
    const sql = SqlService.getInstance()
    // load relevant sources (relevant means: referenced from benchmark)
    const [sources] = await sql.query<CampaignOverviewSources>`
      SELECT
        json_agg(DISTINCT to_jsonb(benchmark_groups)) AS benchmark_groups,
        json_agg(DISTINCT to_jsonb(benchmark_definitions)) AS benchmark_definitions,
        json_agg(DISTINCT to_jsonb(submissions)) AS submissions,
        json_agg(DISTINCT to_jsonb(test_definitions)) AS test_definitions,
        json_agg(DISTINCT to_jsonb(scenario_definitions)) AS scenario_definitions,
        json_agg(DISTINCT to_jsonb(field_definitions)) AS field_definitions,
        json_agg(DISTINCT to_jsonb(results)) AS results
      FROM benchmark_groups
      LEFT JOIN benchmark_definitions ON benchmark_definitions.id = ANY(benchmark_groups.benchmark_ids)
      LEFT JOIN submissions ON submissions.benchmark_id = benchmark_definitions.id AND submissions.published = true
      LEFT JOIN test_definitions ON test_definitions.id = ANY(benchmark_definitions.test_ids)
      LEFT JOIN scenario_definitions ON scenario_definitions.id = ANY(test_definitions.scenario_ids)
      LEFT JOIN field_definitions ON field_definitions.id = ANY(scenario_definitions.field_ids || test_definitions.field_ids || benchmark_definitions.field_ids)
      LEFT JOIN results ON results.scenario_id = scenario_definitions.id AND results.submission_id = submissions.id
      WHERE benchmark_groups.id = ANY(${groupIds})
    `
    return sources
  }

  /**
   * Returns the `FieldDefinitionRow` from `sources` matching `fieldId`.
   */
  findField(
    sources: { field_definitions: (FieldDefinitionRow | null)[] },
    fieldId: string,
  ): FieldDefinitionRow | undefined {
    const field = sources.field_definitions.find((fieldDefRow) => fieldDefRow?.id === fieldId)
    if (!field) {
      logger.warn(`field ${fieldId} not found in sources`, sources.field_definitions as unknown as json)
    }
    return field ?? undefined
  }

  /**
   * Returns the `ScenarioDefinitionRow` from `sources` matching `scenarioId`.
   */
  findScenario(
    sources: { scenario_definitions: (ScenarioDefinitionRow | null)[] },
    scenarioId: string,
  ): ScenarioDefinitionRow | undefined {
    const scenario = sources.scenario_definitions.find((scenarioDefRow) => scenarioDefRow?.id === scenarioId)
    if (!scenario) {
      logger.warn(`scenario ${scenarioId} not found in sources`, sources.scenario_definitions as unknown as json)
    }
    return scenario ?? undefined
  }

  /**
   * Returns the `TestDefinitionRow` from `sources` matching `scenarioId`.
   */
  findTest(sources: { test_definitions: (TestDefinitionRow | null)[] }, testId: string): TestDefinitionRow | undefined {
    const test = sources.test_definitions.find((testDefRow) => testDefRow?.id === testId)
    if (!test) {
      logger.warn(`test ${testId} not found in sources`, sources.test_definitions as unknown as json)
    }
    return test ?? undefined
  }

  /**
   * Returns the `SubmissionRow` from `sources` matching `submissionId`.
   */
  findSubmission(sources: { submissions: (SubmissionRow | null)[] }, submissionId: string): SubmissionRow | undefined {
    const submission = sources.submissions.find((submission) => submission?.id === submissionId)
    if (!submission) {
      logger.warn(`submission ${submissionId} not found in sources`, sources.submissions as unknown as json)
    }
    return submission ?? undefined
  }

  /**
   * Returns the `BenchmarkDefinitionRow` from `sources` matching `benchmarkId`.
   */
  findBenchmark(
    sources: { benchmark_definitions: (BenchmarkDefinitionRow | null)[] },
    benchmarkId: string,
  ): BenchmarkDefinitionRow | undefined {
    const benchmark = sources.benchmark_definitions.find((benchmarkDefRow) => benchmarkDefRow?.id === benchmarkId)
    if (!benchmark) {
      logger.warn(`benchmark ${benchmarkId} not found in sources`, sources.benchmark_definitions as unknown as json)
    }
    return benchmark ?? undefined
  }

  /**
   * Returns the `BenchmarkGroupDefinitionRow` from `sources` matching `groupId`.
   */
  findGroup(
    sources: { benchmark_groups: (BenchmarkGroupDefinitionRow | null)[] },
    groupId: string,
  ): BenchmarkGroupDefinitionRow | undefined {
    const group = sources.benchmark_groups.find((groupDefRow) => groupDefRow?.id === groupId)
    if (!group) {
      logger.warn(`group ${groupId} not found in sources`, sources.benchmark_groups as unknown as json)
    }
    return group ?? undefined
  }

  /**
   * Returns the `FieldDefinitionRow` from `sources` that is the primary field
   * in `entity` (a benchmark, test or scenario definition).
   */
  findPrimaryField(
    sources: { field_definitions: (FieldDefinitionRow | null)[] },
    entity: { field_ids: string[] },
  ): FieldDefinitionRow | undefined {
    const primary = sources.field_definitions.find((fieldDefRow) => fieldDefRow?.id === entity.field_ids[0])
    if (!primary) {
      logger.warn(
        `field ${entity.field_ids[0]} (primary score) not found in sources`,
        sources.field_definitions as unknown as json,
      )
    }
    return primary ?? undefined
  }

  // Score calculation

  /**
   * Calculates `SubmissionScenarioScore` from results according to definitions.
   * @param sources at least all relevant `SubmissionScenarioScoreSources`
   * @param submissionId requested submission ID
   * @param scenarioId requested scenario ID
   */
  calculateSubmissionScenarioScore(
    sources: SubmissionScenarioScoreSources,
    submissionId: string,
    scenarioId: string,
  ): SubmissionScenarioScore {
    logger.trace('calculateSubmissionScenarioScore', { submissionId, scenarioId })
    // prepare node
    const scenarioScored: SubmissionScenarioScore = {
      // submission_id: submissionId,
      scenario_id: scenarioId,
      scorings: {},
    }
    // fill node with available data
    const scenario = this.findScenario(sources, scenarioId)
    if (scenario) {
      const results = sources.results
        .filter((r) => !!r)
        .filter((resultRow) => resultRow.scenario_id === scenarioId && resultRow.submission_id === submissionId)
      scenario.field_ids.forEach((fieldId) => {
        const field = this.findField(sources, fieldId)
        if (field) {
          this.aggregateScore(scenarioScored.scorings, field, [], results)
        }
      })
    }
    return scenarioScored
  }

  /**
   * Calculates `SubmissionTestScore` from results according to definitions.
   * @param sources at least all relevant `SubmissionTestScoreSources`
   * @param submissionId requested submission ID
   * @param testId requested test ID
   */
  calculateSubmissionTestScore(
    sources: SubmissionTestScoreSources,
    submissionId: string,
    testId: string,
  ): SubmissionTestScore {
    logger.trace('calculateSubmissionTestScore', { submissionId, testId })
    // prepare node
    const testScored: SubmissionTestScore = {
      // submission_id: submissionId,
      test_id: testId,
      scorings: {},
      scenario_scorings: [],
    }
    // fill node with available data
    const test = this.findTest(sources, testId)
    if (test) {
      // aggregate child score first
      testScored.scenario_scorings = test.scenario_ids.map((scenarioId) =>
        this.calculateSubmissionScenarioScore(sources, submissionId, scenarioId),
      )
      //... then aggregate own score
      test.field_ids.forEach((fieldId) => {
        const field = this.findField(sources, fieldId)
        if (field) {
          this.aggregateScore(testScored.scorings, field, testScored.scenario_scorings)
        }
      })
    }
    return testScored
  }

  /**
   * Calculates `SubmissionScore` from results according to definitions.
   * @param sources at least all relevant `SubmissionScoreSources`
   * @param submissionId requested submission ID
   */
  calculateSubmissionScore(sources: SubmissionScoreSources, submissionId: string): SubmissionScore {
    logger.trace('calculateSubmissionScore', { submissionId })
    // prepare node
    const submissionScored: SubmissionScore = {
      submission_id: submissionId,
      scorings: {},
      test_scorings: [],
    }
    // fill node with available data
    const submission = this.findSubmission(sources, submissionId)
    if (submission) {
      const benchmarkId = submission.benchmark_id
      const benchmark = this.findBenchmark(sources, benchmarkId)
      if (benchmark) {
        // aggregate child score first
        submissionScored.test_scorings = submission.test_ids.map((testId) =>
          this.calculateSubmissionTestScore(sources, submissionId, testId),
        )
        //... then aggregate own score
        benchmark.field_ids.forEach((fieldId) => {
          const field = this.findField(sources, fieldId)
          if (field) {
            this.aggregateScore(submissionScored.scorings, field, submissionScored.test_scorings)
          }
        })
      }
    }
    return submissionScored
  }

  // Processing

  /**
   * Builds `Leaderboard` from results according to definitions.
   * @param sources at least all relevant `SubmissionScoreSources`
   * @param benchmarkId requested benchmark ID
   */
  buildLeaderboard(sources: SubmissionScoreSources, benchmarkId: string): Leaderboard {
    logger.trace('buildBenchmarkLeaderboard', { benchmarkId })
    // prepare node
    const benchmarkLeaderboard: Leaderboard = {
      benchmark_id: benchmarkId,
      items: [],
    }
    // fill node with available data
    const benchmark = this.findBenchmark(sources, benchmarkId)
    if (benchmark) {
      // build leaderboard by adding scored submissions as items...
      const submissions = sources.submissions
        .filter((s) => !!s)
        .filter((submissionRow) => submissionRow.benchmark_id === benchmarkId)
      benchmarkLeaderboard.items = submissions.map((submission) =>
        this.calculateSubmissionScore(sources, submission.id),
      )
      //... then ranking them
      this.rankBoard(benchmarkLeaderboard)
    }
    return benchmarkLeaderboard
  }

  /**
   * Builds `CampaignItemOverview` from results according to definitions.
   * @param sources at least all relevant `SubmissionScoreSources`
   * @param benchmarkId requested benchmark ID
   */
  buildCampaignItemOverview(sources: SubmissionScoreSources, benchmarkId: string): CampaignItemOverview {
    logger.trace('buildCampaignItemOverview', { benchmarkId })
    // prepare node
    const campaignItemOverview: CampaignItemOverview = {
      benchmark_id: benchmarkId,
      items: [],
      scorings: {},
    }
    // fill node with available data
    const benchmark = this.findBenchmark(sources, benchmarkId)
    if (benchmark) {
      // build leaderboard first
      const board = this.buildLeaderboard(sources, benchmarkId)
      //... then extract top submissions from there
      campaignItemOverview.items = benchmark.test_ids.map((testId) => {
        // extract means: take top solution per test only
        let top: SubmissionScore | undefined
        const test = this.findTest(sources, testId)
        if (test) {
          // then find the one top ranked in test's primary score
          const primary = this.findPrimaryField(sources, test)
          if (primary) {
            top = board.items.find((item) => {
              // there's exactly one test per item in campaign setting
              const testScoring = item.test_scorings[0]
              return testScoring.test_id === testId && testScoring.scorings[primary.key]?.rank === 1
            })
          }
        }
        return {
          test_id: testId,
          // Take top's test[0] scorings instead of top's scorings - because
          // latter are already aggregated with benchmarks' field_definitions.
          // See issue:
          // https://github.com/flatland-association/flatland-benchmarks/issues/320
          scorings: top?.test_scorings[0].scorings ?? null,
          submission_id: top?.submission_id ?? null,
        }
      })
      //... then aggregate own score
      benchmark.field_ids.forEach((fieldId) => {
        const field = this.findField(sources, fieldId)
        if (field) {
          // remap items' "scorings" property to undefined if null for aggregation
          const scorings = campaignItemOverview.items.map((item) => {
            return { scorings: item.scorings ?? undefined }
          })
          this.aggregateScore(campaignItemOverview.scorings, field, scorings)
        }
      })
    }
    return campaignItemOverview
  }

  /**
   * Builds `CampaignOverview` from results according to definitions.
   * @param sources at least all relevant `CampaignOverviewSources`
   * @param groupId requested group ID
   */
  buildCampaignOverview(sources: CampaignOverviewSources, groupId: string): CampaignOverview {
    logger.trace('buildCampaignOverview', { groupId })
    // prepare node
    const campaignOverview: CampaignOverview = {
      group_id: groupId,
      items: [],
    }
    // fill node with available data
    const group = this.findGroup(sources, groupId)
    if (group) {
      // build item overviews for all benchmarks in group
      campaignOverview.items = group.benchmark_ids.map((benchmarkId) =>
        this.buildCampaignItemOverview(sources, benchmarkId),
      )
    }
    return campaignOverview
  }

  // Internals

  /**
   * Aggregates scores from subordinate scorings (`children` or `results`) into
   * `scorings` using the defined aggregation in `field`.
   */
  aggregateScore(
    scorings: Scorings,
    field: FieldDefinitionRow,
    children: { scorings?: Scorings }[],
    results: ResultRow[] = [],
  ) {
    // if agg_func is nullish, take first match from results
    if (!field.agg_func) {
      const fieldName = this.getInFieldName(field, 0)
      scorings[field.key] = {
        score: results.find((result) => result.key === fieldName)?.value ?? null,
      }
    }
    // otherwise, aggregate accordingly
    else {
      let values: (number | null)[]
      // collect scores from children matching in_field
      if (!field.agg_lateral) {
        // REMARK: error when number of fields doesn't match number of scores?
        values = children.map((child, index) => {
          const fieldName = this.getInFieldName(field, index)
          return fieldName ? (child.scorings?.[fieldName]?.score ?? null) : null
        })
      }
      // collect scores from collected scores matching in_field
      else {
        values = []
        for (let index = 0; index < (Array.isArray(field.agg_fields) ? field.agg_fields.length : 1); index++) {
          const fieldName = this.getInFieldName(field, index)
          values.push(fieldName ? (scorings[fieldName]?.score ?? null) : null)
        }
      }
      // weigh
      if (field.agg_weights) {
        // REMARK: extra values (when more values than weighs) will be 0
        for (let i = 0; i < values.length; i++) {
          if (values[i] !== null) {
            values[i]! *= field.agg_weights[i] ?? 0
          }
        }
      }
      // aggregate values
      scorings[field.key] = {
        score: this.runAggregationFunction(values, field.agg_func),
      }
    }
  }

  /**
   * Returns the field name of the subordinate scoring, which is either
   * explicitly defined in `agg_fields` or falls back to the field's own key.
   */
  getInFieldName(field: FieldDefinitionRow, index: number): string | undefined {
    // if agg_fields is nullish, return field key
    if (!field.agg_fields) {
      return field.key
    } else if (typeof field.agg_fields === 'string') {
      return field.agg_fields
    } else {
      // returns undefined when out-of-bounds
      return field.agg_fields[index]
    }
  }

  // since JSON can't express NaN, use null in its place
  runAggregationFunction(values: (number | null)[], func: string) {
    switch (func) {
      // sum
      case 'SUM':
        return this.aggSum(values)
      case 'NANSUM':
        return this.aggNaNSum(values)
      // mean
      case 'MEAN':
        return this.aggMean(values)
      case 'NANMEAN':
        return this.aggNaNMean(values)
      // median
      case 'MEDIAN':
        return this.aggMedian(values)
      case 'NANMEDIAN':
        return this.aggNaNMedian(values)
      default:
        return null
    }
  }

  /**
   * Calculates sum, returns `null` if there's a `null` in values.
   */
  aggSum(values: (number | null)[]) {
    let sum = 0
    for (const value of values) {
      // null? early abort
      if (value === null) return null
      sum += value
    }
    return sum
  }

  /**
   * Calculates sum over all non-`null` values.
   */
  aggNaNSum(values: (number | null)[]) {
    return this.aggSum(values.filter((v) => v !== null))
  }

  /**
   * Calculates mean, returns `null` if there's a `null` in values.
   */
  aggMean(values: (number | null)[]) {
    // empty set defaults to null
    if (values.length === 0) return null
    const sum = this.aggSum(values)
    return sum !== null ? sum / values.length : null
  }

  /**
   * Calculates mean over all non-`null` values.
   */
  aggNaNMean(values: (number | null)[]) {
    return this.aggMean(values.filter((v) => v !== null))
  }

  /**
   * Calculates median, returns `null` if there's a `null` in values.
   */
  aggMedian(values: (number | null)[]) {
    // empty set defaults to null
    if (values.length === 0) return null
    // having null results in null
    if (values.some((score) => score === null)) return null
    // calculate median
    values.sort((a, b) => (a as number) - (b as number))
    if (values.length % 2 === 1) {
      const i = (values.length - 1) / 2
      return values[i]
    } else {
      const i = (values.length - 2) / 2
      return ((values[i] as number) + (values[i + 1] as number)) / 2
    }
  }

  /**
   * Calculates median over all non-`null` values.
   */
  aggNaNMedian(values: (number | null)[]) {
    return this.aggMedian(values.filter((v) => v !== null))
  }

  /**
   * Fills rank, highest and lowest score of every scoring in all items.
   */
  rankBoard(board: { items: SubmissionScore[] }) {
    // Build a table with one row per submission and one column for each
    // submission total/test/scenario score (every field) and then rank every
    // column.

    // First: flatten items and determine column names
    const columns = new Set<string>()
    const addToRow = (row: Record<string, Scoring>, item: { scorings: Scorings }, prefix = '') => {
      for (const key in item.scorings) {
        const column = prefix + key
        columns.add(column)
        const scoring = item.scorings[key]
        if (scoring) {
          row[column] = scoring
        }
      }
    }
    const rows = board.items.map((item) => {
      const row: Record<string, Scoring> = {}
      // totals
      addToRow(row, item)
      // test scores
      item.test_scorings.forEach((test) => {
        addToRow(row, test, test.test_id)
        // scenario scores
        test.scenario_scorings.forEach((scenario) => {
          addToRow(row, scenario, scenario.scenario_id)
        })
      })
      return row
    })

    // Second: go through all columns and rank (sort & determine highest/lowest)
    columns.forEach((column) => {
      // sort rows in place
      // (they're disconnected from board items and won't affect those)
      rows.sort((a, b) => {
        const scoringA = a[column]
        const scoringB = b[column]
        // for comparison, treat absent score like -inf (will put it last)
        const scoreA = scoringA?.score ?? Number.NEGATIVE_INFINITY
        const scoreB = scoringB?.score ?? Number.NEGATIVE_INFINITY
        // desc sort (b before a)
        return scoreB - scoreA
      })
      // During sort, absent scores are treated as -inf. During ranking, absent
      // scores lead to submissions being skipped. This shouldn't be an issue,
      // as -inf scored submissions are put to the very end, where skipping
      // doesn't matter.
      let highest = 0
      let lowest = 0 // per default, assume 0 being lowest score
      let prevScore = Number.POSITIVE_INFINITY
      let rank = 0
      // rank - index does not match rank exactly, as multiple submissions could
      // land on same rank
      rows.forEach((row, index) => {
        const scoring = row[column]
        if (scoring) {
          const score = scoring.score ?? Number.NEGATIVE_INFINITY
          // count rank up when score decreased
          if (score < prevScore) {
            rank = index + 1
            prevScore = score
          }
          scoring.rank = rank
          // track highest and lowest score
          if (score > highest) {
            highest = score
          }
          if (score > Number.NEGATIVE_INFINITY && score < lowest) {
            lowest = score
          }
        }
      })
      // store highest and lowest score in every scoring
      rows.forEach((row) => {
        const scoring = row[column]
        if (scoring) {
          scoring.highest = highest
          scoring.lowest = lowest
        }
      })
    })
  }
}
