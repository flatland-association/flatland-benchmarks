// TODO: move interfaces to common and merge with common interfaces

import {
  BenchmarkDefinitionRow,
  FieldDefinitionRow,
  ResultRow,
  ScenarioDefinitionRow,
  Scorings,
  SubmissionRow,
  TestDefinitionRow,
} from '@common/interfaces'
import { Logger } from '../logger/logger.mjs'

const logger = new Logger('aggregator')

/*
REMARK:

Definition tree is like this:

BenchmarkGroupDefinition - a group of benchmark definitions
└ BenchmarkDefinition[] - benchmark, group of test definitions
  └ TestDefinition[] - available tests
    └ ScenarioDefinition[] - defined scenarios per test


Aggregated/scored structure is like this:

In competition setting:
Leaderboard -  i.e. a list of scored submissions
└ SubmissionScored[] - scored submissions (scores aggregated at test level and aggregated at benchmark level from tests), a submission refers to exactly one benchmark by definition
  └ TestScored[] - scored tests (aggregated from scenarios)
    └ ScenarioScored[] - scored scenarios

In campaign setting:
Campaign Overview: list of CampaignItems
└ CampaignItem -  a benchmark scored by aggregation of the best test score; the best test from all SubmissionScored
  └ SubmissionScored[] - scored submissions (aggregated per test, aggregation at benchmark level ignored)
    └ TestScored[] - idem
      └ ScenarioScored[] - idem

N.B. the scored tree knows a level between benchmarks and tests (submissions).

*/

// TODO: find a generic way to do all this (the interfaces for definition objects and the upcast row -> object)
export interface ScenarioDefinition extends Omit<ScenarioDefinitionRow, 'field_definition_ids'> {
  field_definitions: (FieldDefinitionRow | null)[]
}

export function upcastScenarioDefinitionRow(
  row: ScenarioDefinitionRow,
  fieldDefinitionCandidates: FieldDefinitionRow[],
): ScenarioDefinition {
  return {
    dir: row.dir,
    id: row.id,
    name: row.name,
    description: row.description,
    field_definitions: row.field_definition_ids.map((id) => fieldDefinitionCandidates.find((c) => c.id === id) ?? null),
  }
}

export interface TestDefinition extends Omit<TestDefinitionRow, 'field_definition_ids' | 'scenario_definition_ids'> {
  field_definitions: (FieldDefinitionRow | null)[]
  scenario_definitions: (ScenarioDefinition | null)[]
}

export function upcastTestDefinitionRow(
  row: TestDefinitionRow,
  fieldDefinitionCandidates: FieldDefinitionRow[],
  scenarioDefinitionCandidates: ScenarioDefinitionRow[],
): TestDefinition {
  return {
    dir: row.dir,
    id: row.id,
    name: row.name,
    description: row.description,
    field_definitions: row.field_definition_ids.map((id) => fieldDefinitionCandidates.find((c) => c.id === id) ?? null),
    scenario_definitions: row.scenario_definition_ids.map((id) => {
      const scenario = scenarioDefinitionCandidates.find((c) => c.id === id) ?? null
      if (scenario) {
        return upcastScenarioDefinitionRow(scenario, fieldDefinitionCandidates)
      } else {
        return null
      }
    }),
    loop: row.loop,
  }
}

export interface BenchmarkDefinition
  extends Omit<BenchmarkDefinitionRow, 'field_definition_ids' | 'test_definition_ids'> {
  /**
   * Defines aggregation of test scores in context:
   * - competition; to submission overall score
   * - campaign; to benchmark overall score
   */
  field_definitions: (FieldDefinitionRow | null)[]
  test_definitions: (TestDefinition | null)[]
}

export function upcastBenchmarkDefinitionRow(
  row: BenchmarkDefinitionRow,
  fieldDefinitionCandidates: FieldDefinitionRow[],
  scenarioDefinitionCandidates: ScenarioDefinitionRow[],
  testDefinitionCandidates: TestDefinitionRow[],
): BenchmarkDefinition {
  return {
    dir: row.dir,
    id: row.id,
    name: row.name,
    description: row.description,
    field_definitions: row.field_definition_ids.map((id) => fieldDefinitionCandidates.find((c) => c.id === id) ?? null),
    test_definitions: row.test_definition_ids.map((id) => {
      const test = testDefinitionCandidates.find((c) => c.id === id) ?? null
      if (test) {
        return upcastTestDefinitionRow(test, fieldDefinitionCandidates, scenarioDefinitionCandidates)
      } else {
        return null
      }
    }),
  }
}

// TODO: Benchmark Groups

export interface Submission extends Omit<SubmissionRow, 'benchmark_definition_id' | 'test_definition_ids'> {
  benchmark_definition: BenchmarkDefinition | null
  test_definitions: (TestDefinition | null)[]
}

export function upcastSubmissionRow(
  row: SubmissionRow,
  fieldDefinitionCandidates: FieldDefinitionRow[],
  scenarioDefinitionCandidates: ScenarioDefinitionRow[],
  testDefinitionCandidates: TestDefinitionRow[],
  benchmarkDefinitionCandidates: BenchmarkDefinitionRow[],
): Submission {
  const benchmarkDef = benchmarkDefinitionCandidates.find((c) => c.id === row.benchmark_id) ?? null
  return {
    dir: row.dir,
    id: row.id,
    benchmark_definition: benchmarkDef
      ? upcastBenchmarkDefinitionRow(
          benchmarkDef,
          fieldDefinitionCandidates,
          scenarioDefinitionCandidates,
          testDefinitionCandidates,
        )
      : null,
    test_definitions: row.test_ids.map((id) => {
      const test = testDefinitionCandidates.find((c) => c.id === id) ?? null
      if (test) {
        return upcastTestDefinitionRow(test, fieldDefinitionCandidates, scenarioDefinitionCandidates)
      } else {
        return null
      }
    }),
    name: row.name,
    description: row.description,
    submission_data_url: row.submission_data_url,
    code_repository: row.code_repository,
    submitted_at: row.submitted_at,
    submitted_by: row.submitted_by,
    submitted_by_username: row.submitted_by_username,
    status: row.status,
    published: row.published,
  }
}

export interface ScenarioScoredEx {
  definition: ScenarioDefinition
  scorings: Scorings
}

export interface TestScoredEx {
  definition: TestDefinition
  scorings: Scorings
  scenarios: ScenarioScoredEx[]
}

// required in competition context
export interface LeaderboardItemEx {
  submission: Submission
  tests: TestScoredEx[]
  scorings: Scorings
}

export interface LeaderboardEx {
  benchmark: BenchmarkDefinition
  items: LeaderboardItemEx[]
}

// required in campaign context
export interface CampaignItemEx {
  benchmark: BenchmarkDefinition
  test: TestDefinition
  item: LeaderboardItemEx | undefined
}

interface ScoringHost {
  level: 'benchmark' | 'submission' | 'test' | 'scenario'
  id?: string
}

export class Aggregator {
  /**
   * Leaderboard: list of scored submissions (LeaderboardItems) for benchmark.
   * In order to establish rankings, all submissions with their results have to
   * be passed whenever the leaderboard is built.
   * @param benchmarkDef
   * @param submissions
   * @param results
   */
  static getLeaderboard(
    benchmarkDef: BenchmarkDefinition,
    submissions: Submission[],
    results: ResultRow[],
  ): LeaderboardEx {
    // prepare tree structure (containing submissions as items)
    const leaderboard: LeaderboardEx = {
      benchmark: benchmarkDef,
      // only consider submissions made for requested benchmark, otherwise
      // ranking could show unexpected results
      items: submissions
        .filter((submission) => submission.benchmark_definition?.id === benchmarkDef.id)
        .map((submission) =>
          this.getSubmissionScored(
            benchmarkDef,
            submission,
            results.filter((result) => result.submission_id === submission.id),
          ),
        ),
    }
    // second (now that all items are scored), rank items
    this.rankLeaderboard(leaderboard, 'scenario')
    return leaderboard
  }

  /**
   * Applies results to a benchmark's tests, filters the top solution, then
   * aggregates those.
   * @param benchmarkDef
   * @param submission
   * @param results
   */
  // TODO: naming
  static getCampaignItemScored(
    benchmarkDef: BenchmarkDefinition,
    submissions: Submission[],
    results: ResultRow[],
  ): CampaignItemEx[] {
    // build leaderboard first (might not contain rows for each test)
    // TODO: either skip submission ranking or ensure submission total equals test total in campaign case
    const leaderboard = this.getLeaderboard(benchmarkDef, submissions, results)
    // remap to campaign (exactly one row per test, containing top submission of that test)
    const campaign = benchmarkDef.test_definitions
      .filter((t) => !!t)
      .map((testDef) => {
        // REMARK: Comparing by object equality does not work in application,
        // looks like upcast from rows does not create unique copies...
        const top = leaderboard.items.find(
          (item) =>
            item.tests[0].definition.id === testDef.id &&
            // find top item at test level
            this.getPrimaryScoring(item.tests[0].scorings, benchmarkDef.field_definitions)?.rank === 1,
        )
        return {
          benchmark: benchmarkDef,
          test: testDef,
          item: top,
        } satisfies CampaignItemEx
      })
    return campaign
  }

  /**
   * Applies results to a submission's tests, then aggregates those.
   * @param benchmarkDef Parent benchmark (required for field definitions).
   * @param submission Submission to score.
   * @param results Results filtered by submission.
   * @returns LeaderboardItem with scoring, but not yet ranked.
   */
  static getSubmissionScored(
    benchmarkDef: BenchmarkDefinition,
    submission: Submission,
    results: ResultRow[],
  ): LeaderboardItemEx {
    // prepare tree structure (containing scored tests)
    const item: LeaderboardItemEx = {
      submission,
      tests: submission.test_definitions.filter((f) => !!f).map((test) => this.getTestScored(test, results)),
      scorings: {},
    }
    // second (once children are scored), aggregate own score
    benchmarkDef.field_definitions
      .filter((f) => !!f)
      .forEach((field) => {
        this.aggregateScore(item.scorings, field, item.tests)
      })
    return item
  }

  /**
   * Applies results to a test's scenarios, then aggregates those.
   * @param test Test of submission to score.
   * @param results Results filtered by submission.
   * @returns TestScored with scoring, but not yet ranked.
   */
  static getTestScored(test: TestDefinition, results: ResultRow[]): TestScoredEx {
    // prepare tree structure (containing scored scenarios)
    const testScored: TestScoredEx = {
      definition: test,
      scenarios: test.scenario_definitions
        .filter((s) => !!s)
        .map((scenario) =>
          this.getScenarioScored(
            scenario,
            results.filter((result) => result.scenario_definition_id === scenario.id),
          ),
        ),
      scorings: {},
    }
    // once children are appended and scored, it's safe to aggregate score
    test.field_definitions
      .filter((f) => !!f)
      .forEach((field) => {
        this.aggregateScore(testScored.scorings, field, testScored.scenarios)
      })
    return testScored
  }

  /**
   * Applies results to scenario.
   * @param scenario Scenario of submission to score.
   * @param results Results filtered by submission and scenario.
   * @returns ScenarioScored with scoring, but not yet ranked.
   */
  static getScenarioScored(scenario: ScenarioDefinition, results: ResultRow[]): ScenarioScoredEx {
    // build leaf
    const scenarioScored: ScenarioScoredEx = {
      definition: scenario,
      scorings: {},
    }
    // once tree is built, it's safe to aggregate score
    scenario.field_definitions
      .filter((f) => !!f)
      .forEach((field) => {
        this.aggregateScore(scenarioScored.scorings, field, [], results)
      })
    return scenarioScored
  }

  static aggregateScore(
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
      // aggregate values
      scorings[field.key] = {
        score: this.runAggregation(values, field.agg_func),
      }
    }
  }

  static getInFieldName(field: FieldDefinitionRow, index: number): string | undefined {
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
  static runAggregation(scores: (number | null)[], func: string) {
    switch (func) {
      // sum
      case 'SUM':
      case 'NANSUM': {
        // NANx - filter null
        if (func === 'NANSUM') scores = scores.filter((score) => score !== null)
        // empty set defaults to 0
        if (scores.length === 0) return 0
        // sum up
        return this.sum(scores)
      }
      // mean
      case 'MEAN':
      case 'NANMEAN': {
        // NANx - filter null
        if (func === 'NANMEAN') scores = scores.filter((score) => score !== null)
        // empty set defaults to null
        if (scores.length === 0) return null
        // mean
        const sum = this.sum(scores)
        return sum !== null ? sum / scores.length : null
      }
      // median
      case 'MEDIAN':
      case 'NANMEDIAN': {
        // NANx - filter null
        if (func === 'NANMEDIAN') scores = scores.filter((score) => score !== null)
        // empty set defaults to null
        if (scores.length === 0) return null
        // having null results in null
        if (scores.some((score) => score === null)) return null
        // sort scores
        scores.sort((a, b) => (a as number) - (b as number))
        // median
        if (scores.length % 2 === 1) {
          const i = (scores.length - 1) / 2
          return scores[i]
        } else {
          const i = (scores.length - 2) / 2
          return ((scores[i] as number) + (scores[i + 1] as number)) / 2
        }
      }
      default:
        return null
    }
  }

  /**
   * Sums, returns `null` if there's a `null` in values.
   * @param values Values to sum
   * @returns Sum. Or `null`
   */
  static sum(values: (number | null)[]) {
    let sum = 0
    for (const value of values) {
      // null? early abort
      if (value === null) return null
      sum += value
    }
    return sum
  }

  /**
   * Returns the primary scoring, assuming the first field definition is always
   * the primary score.
   */
  static getPrimaryScoring(scorings: Scorings, fieldDefs: (FieldDefinitionRow | null)[]) {
    if (!fieldDefs || !fieldDefs[0]) return null
    const key = fieldDefs[0].key
    return scorings[key]
  }

  // Level of detail has no upper bound because i.o.t. rank, the whole
  // benchmark has to be considered anyways.
  static rankLeaderboard(leaderboard: LeaderboardEx, lod?: 'test' | 'scenario') {
    // find rank-able/relevant fields
    const rankables: { field: string; from: ScoringHost }[] = []
    // always include top level scorings (top level rank-able is submission)
    leaderboard.benchmark.field_definitions
      .filter((f) => !!f)
      .forEach((field) => {
        rankables.push({
          field: field.key,
          from: { level: 'submission' },
        })
      })
    if (lod === 'test' || lod === 'scenario') {
      leaderboard.benchmark.test_definitions
        .filter((t) => !!t)
        .forEach((test) => {
          test.field_definitions
            .filter((f) => !!f)
            .forEach((field) => {
              rankables.push({
                field: field.key,
                from: { level: 'test', id: test.id },
              })
            })
        })
      if (lod === 'scenario') {
        leaderboard.benchmark.test_definitions
          .filter((t) => !!t)
          .forEach((test) => {
            test.scenario_definitions
              .filter((s) => !!s)
              .forEach((scenario) => {
                scenario.field_definitions
                  .filter((f) => !!f)
                  .forEach((field) => {
                    rankables.push({
                      field: field.key,
                      from: { level: 'scenario', id: scenario.id },
                    })
                  })
              })
          })
      }
    }
    // rank those fields
    rankables.forEach((rankable) => {
      this.rankField(leaderboard.items, rankable.field, rankable.from)
    })
  }

  // it's always submissions being ranked, but the field differs
  // REMARK: probably noticeable performance bottleneck (tree gets scanned multiple times)
  // TODO: check if optimization is necessary (maybe put tests in an object instead of array for direct access..?)
  /**
   * Ranks an item by specified field (which can also be a field from a specific
   * test / scenario). Ranking will populate `rank`, `highest` and `lowest`
   * @param items Items to compare.
   * @param field Key of field to rank by.
   * @param from Where said field can be found (submission, specific test or specific scenario).
   */
  static rankField(items: LeaderboardItemEx[], field: string, from: ScoringHost) {
    // can't rank benchmarks
    if (from.level === 'benchmark') return
    const getScorings = (submission: LeaderboardItemEx, from: ScoringHost) => {
      if (from.level === 'submission') {
        return submission.scorings
      } else if (from.level === 'test') {
        return submission.tests.find((test) => test.definition.id === from.id)?.scorings ?? null
      } else if (from.level === 'scenario') {
        for (const test of submission.tests) {
          const scenario = test.scenarios.find((scenario) => scenario.definition.id === from.id)
          if (scenario) return scenario.scorings
        }
      }
      return null
    }
    // sort submissions by relevant field
    items = items.sort((a, b) => {
      const sourceA = getScorings(a, from)
      const sourceB = getScorings(b, from)
      // for comparison, treat null like -inf
      const scoreA = sourceA?.[field]?.score ?? Number.NEGATIVE_INFINITY
      const scoreB = sourceB?.[field]?.score ?? Number.NEGATIVE_INFINITY
      // desc sort (b before a)
      return scoreB - scoreA
    })
    // During sort, absent scores are treated as -inf, during ranking absent
    // scores lead to submissions being skipped. This shouldn't be an issue,
    // as -inf scored submissions are put to the very end, where skipping
    // doesn't matter.
    let highest = 0
    let lowest = 0 // per default, assume 0 being lowest score
    let prevScore = Number.POSITIVE_INFINITY
    let rank = 0
    // rank - after sorting, index + 1 almost equals rank
    // (except where score is equal to prev rank)
    for (let index = 0; index < items.length; index++) {
      const item = items[index]
      const scoring = getScorings(item, from)?.[field]
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
    }
    // store highest and lowest score in each scoring
    for (const item of items) {
      const scoring = getScorings(item, from)?.[field]
      if (scoring) {
        scoring.highest = highest
        scoring.lowest = lowest
      }
    }
  }
}
