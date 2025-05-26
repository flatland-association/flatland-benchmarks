// TODO: move interfaces to common and merge with common interfaces

/*
REMARK:

Definition tree is like this:

BenchmarkGroupDefinition - a group of benchmark definitions
└ BenchmarkDefinition[] - benchmark, group of test definitions
  └ TestDefinition[] - available tests
    └ ScenarioDefinition[] - defined scenarios per test


Aggregated/scored structure is like this:

BenchmarkGroupScored - a group of benchmark definitions
└ BenchmarkScored[] - scored benchmarks
  └ SubmissionScored[] - scored submissions
    └ TestScored[] - scored tests
      └ ScenarioScored[] - defined scenarios per test

N.B. the scored tree knows a level between benchmarks and tests (submissions).

Ideally, the two trees would match in overall structure. Currently this is
achieved by moving the field definitions from BenchmarkDefinition to a
separate `SubmissionDefinition` in `getBenchmarkScored`.

(I would like to normalize that, i.e. introduce `SubmissionDefinition` in the
DB schema.)

Question: Could a benchmark possibly have multiple SubmissionDefinitions (then
the submission would have to explicitly link to that) or is there always exactly
one of those per benchmark (then the SubmissionDefinition can be inferred from
a submission's linked benchmark).

*/

export interface FieldDefinition {
  /** Name of field, how it's exposed */
  out_field: string
  // REMARK: introduced order to be able to define primary/secondary etc for
  // sorting when a score is missing (this is hypothetical RN, haven't really
  // thought through if that case is possible)
  /**
   * Order of field, 0 indicates the primary score.
   * Optional, falls back to order of appearance.
   */
  order?: number
  /**
   * Aggregation function to use for aggregated fields (optional, if undefined
   * the field score is taken from the table directly)
   */
  agg_func?: string
  in_fields?: string | string[]
  weights?: number[]
  agg_lateral?: boolean
}

export interface ScenarioDefinition {
  id: string
  test_id: string
  // REMARK: redundant:
  // benchmark_id: string
  name: string
  description: string
  fields: FieldDefinition[]
}

export interface TestDefinition {
  id: string
  benchmark_id: string
  name: string
  fields: FieldDefinition[]
}

// REMARK: not yet a thing - see first remark
export interface SubmissionDefinition {
  fields: FieldDefinition[]
}

export interface BenchmarkDefinition {
  id: string
  name: string
  // REMARK: field definitions for aggregation on submission level
  submission_fields: FieldDefinition[]
  // REMARK: field definitions for aggregation on benchmark level
  fields: FieldDefinition[]
}

export interface Result {
  scenario_id: string
  submission_id: string
  key: string
  score: number
}

export interface Submission {
  id: string
  status: 'SUBMITTED' | 'RUNNING' | 'SUCCESS' | 'FAILURE'
  benchmark_id: string
  description: string
  published: boolean
  tests: string[]
}

export interface Scoring {
  score: number | null
  rank?: number
  top?: number // REMARK: it's my full intention repeating the top score in every scoring. That way, submissions/tests can be filtered without losing this information.
}

export type Scorings = Record<string, Scoring | null>

export interface ScenarioScored {
  definition: ScenarioDefinition
  scorings: Scorings
}

export interface TestScored {
  definition: TestDefinition
  scorings: Scorings
  scenarios: ScenarioScored[]
}

export interface SubmissionScored {
  definition: SubmissionDefinition
  submission: Submission
  scorings: Scorings
  tests: TestScored[]
}

export interface BenchmarkScored {
  definition: BenchmarkDefinition
  scorings: Scorings
  submissions: SubmissionScored[]
}

export interface BenchmarkGroupScored {
  benchmarks: BenchmarkScored[]
}

interface ScoringHost {
  level: 'benchmark' | 'submission' | 'test' | 'scenario'
  id?: string
}

export class Aggregator {
  static getBenchmarkGroupScored(
    benchmarkDefs: BenchmarkDefinition[],
    // REMARK: logically:
    // submissionDefs: SubmissionDefinition[],
    testDefs: TestDefinition[],
    scenarioDefs: ScenarioDefinition[],
    submissions: Submission[],
    results: Result[],
  ): BenchmarkGroupScored {
    // build tree (without score) top-down
    const groupScored: BenchmarkGroupScored = {
      benchmarks: benchmarkDefs.map((benchmark) =>
        this.getBenchmarkScored(
          benchmark,
          // submissionDefs,
          testDefs,
          scenarioDefs,
          submissions,
          results,
        ),
      ),
    }
    return groupScored
  }

  // REMARK: these are private since calling them bypassing
  // `getBenchmarkGroupScored` also bypasses ranking...
  private static getBenchmarkScored(
    benchmarkDef: BenchmarkDefinition,
    // submissionDefs: SubmissionDefinition[],
    testDefs: TestDefinition[],
    scenarioDefs: ScenarioDefinition[],
    submissions: Submission[],
    results: Result[],
  ): BenchmarkScored {
    // build tree structure
    const benchmarkScored: BenchmarkScored = {
      definition: benchmarkDef,
      submissions: submissions
        .filter((submission) => submission.benchmark_id === benchmarkDef.id)
        .map((submission) =>
          this.getSubmissionScored(
            // REMARK: build SubmissionDef on-the-fly, see first remark
            { fields: benchmarkDef.submission_fields },
            testDefs,
            scenarioDefs,
            submission,
            results.filter((result) => result.submission_id === submission.id),
          ),
        ),
      scorings: {},
    }
    // once children are appended and scored, it's safe to aggregate score
    benchmarkDef.fields.forEach((field) => {
      this.aggregateScore(benchmarkScored.scorings, field, benchmarkScored.submissions, results)
    })
    // once everything is scored, it's safe to rank
    this.rankBenchmark(benchmarkScored, 'scenario')
    return benchmarkScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results for submission.
   */
  private static getSubmissionScored(
    submissionDef: SubmissionDefinition,
    testDefs: TestDefinition[],
    scenarioDefs: ScenarioDefinition[],
    submission: Submission,
    results: Result[],
  ): SubmissionScored {
    // build tree structure
    const submissionScored: SubmissionScored = {
      definition: submissionDef,
      submission: submission,
      tests: testDefs
        .filter((test) => submission.tests.includes(test.id))
        .map((test) => this.getTestScored(test, scenarioDefs, results)),
      scorings: {},
    }
    // once children are appended and scored, it's safe to aggregate score
    submissionDef.fields.forEach((field) => {
      this.aggregateScore(submissionScored.scorings, field, submissionScored.tests, results)
    })
    return submissionScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results for submission.
   */
  private static getTestScored(test: TestDefinition, scenarios: ScenarioDefinition[], results: Result[]): TestScored {
    // build tree structure
    const testScored: TestScored = {
      definition: test,
      scenarios: scenarios
        .filter((scenario) => scenario.test_id === test.id)
        .map((scenario) =>
          this.getScenarioScored(
            scenario,
            results.filter((result) => result.scenario_id === scenario.id),
          ),
        ),
      scorings: {},
    }
    // once children are appended and scored, it's safe to aggregate score
    test.fields.forEach((field) => {
      this.aggregateScore(testScored.scorings, field, testScored.scenarios, results)
    })
    return testScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results for scenario.
   */
  private static getScenarioScored(scenario: ScenarioDefinition, results: Result[]): ScenarioScored {
    // build leaf
    const scenarioScored: ScenarioScored = {
      definition: scenario,
      scorings: {},
    }
    // once tree is built, it's safe to aggregate score
    scenario.fields.forEach((field) => {
      this.aggregateScore(scenarioScored.scorings, field, [], results)
    })
    return scenarioScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results.
   */
  static aggregateScore(
    scorings: Scorings,
    field: FieldDefinition,
    children: { scorings?: Scorings }[],
    results: Result[],
  ) {
    // if agg_func is undefined, take first match from results
    if (typeof field.agg_func === 'undefined') {
      const fieldName = this.getInFieldName(field, 0)
      scorings[field.out_field] = {
        score: results.find((result) => result.key === fieldName)?.score ?? null,
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
        for (let index = 0; index < (Array.isArray(field.in_fields) ? field.in_fields.length : 1); index++) {
          const fieldName = this.getInFieldName(field, index)
          values.push(fieldName ? (scorings[fieldName]?.score ?? null) : null)
        }
      }
      // aggregate values
      scorings[field.out_field] = {
        score: this.runAggregation(values, field.agg_func),
      }
    }
  }

  static getInFieldName(field: FieldDefinition, index: number): string | undefined {
    if (typeof field.in_fields === 'undefined') {
      return field.out_field
    } else if (typeof field.in_fields === 'string') {
      return field.in_fields
    } else {
      // returns undefined when out-of-bounds
      return field.in_fields[index]
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

  // Level of detail has no upper bound because i.o.t. rank, the whole
  // benchmark has to be considered anyways.
  static rankBenchmark(benchmark: BenchmarkScored, lod?: 'test' | 'scenario') {
    // find rank-able/relevant fields
    const rankables: { field: string; from: ScoringHost }[] = []
    // always include top level scorings (top level rank-able is submission)
    benchmark.definition.submission_fields.forEach((field) => {
      rankables.push({
        field: field.out_field,
        from: { level: 'submission' },
      })
    })
    // REMARK: gathering tests and scenarios traverses the tree multiple times,
    // maybe instead pre-build a definitions tree
    if (lod === 'test' || lod === 'scenario') {
      // find fields from test
      // REMARK: this skips tests that weren't selected in submissions (is this an issue?)
      const tests = new Set<TestScored>()
      benchmark.submissions.forEach((submission) => {
        submission.tests.forEach((test) => tests.add(test))
      })
      tests.forEach((test) => {
        test.definition.fields.forEach((field) => {
          rankables.push({
            field: field.out_field,
            from: { level: 'test', id: test.definition.id },
          })
        })
      })
      if (lod === 'scenario') {
        // find fields from scenarios
        const scenarios = new Set<ScenarioScored>()
        tests.forEach((test) => {
          test.scenarios.forEach((scenario) => scenarios.add(scenario))
        })
        scenarios.forEach((scenario) => {
          scenario.definition.fields.forEach((field) => {
            rankables.push({
              field: field.out_field,
              from: { level: 'scenario', id: scenario.definition.id },
            })
          })
        })
      }
    }
    // rank those fields
    rankables.forEach((rankable) => {
      this.rankField(benchmark.submissions, rankable.field, rankable.from)
    })
  }

  // it's always submissions being ranked, but the field differs
  // REMARK: probably noticeable performance bottleneck (tree gets scanned multiple times)
  // TODO: check if optimization is necessary (maybe put tests in an object instead of array for direct access..?)
  static rankField(submissions: SubmissionScored[], field: string, from: ScoringHost) {
    // can't rank benchmarks
    if (from.level === 'benchmark') return
    const getScorings = (submission: SubmissionScored, from: ScoringHost) => {
      // if no from is specified, take aggregated score from level submission
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
    submissions = submissions.sort((a, b) => {
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
    let best = 0
    let prevScore = Number.POSITIVE_INFINITY
    let rank = 0
    // rank - after sorting, index almost equals rank
    // (except where score is equal to prev rank)
    for (let index = 0; index < submissions.length; index++) {
      const submission = submissions[index]
      const scoring = getScorings(submission, from)?.[field]
      if (scoring) {
        const score = scoring.score ?? Number.NEGATIVE_INFINITY
        // count rank up when score decreased
        if (score < prevScore) {
          rank = index + 1
          prevScore = score
          if (score > best) {
            best = score
          }
        }
        scoring.rank = rank
        scoring.top = best
      }
    }
  }
}
