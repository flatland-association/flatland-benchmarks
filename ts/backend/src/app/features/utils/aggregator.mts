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

export type Scores = Record<string, number | null>

export interface ScenarioScored {
  definition: ScenarioDefinition
  scores: Scores
}

export interface TestScored {
  definition: TestDefinition
  scores: Scores
  scenarios: ScenarioScored[]
}

export interface SubmissionScored {
  definition: SubmissionDefinition
  submission: Submission
  scores: Scores
  tests: TestScored[]
}

export interface BenchmarkScored {
  definition: BenchmarkDefinition
  scores: Scores
  submissions: SubmissionScored[]
}

export interface BenchmarkGroupScored {
  scores: Scores
  benchmarks: BenchmarkScored[]
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
      scores: {},
    }
    return groupScored
  }

  static getBenchmarkScored(
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
      scores: {},
    }
    // once children are appended and scored, it's safe to aggregate score
    benchmarkDef.fields.forEach((field) => {
      this.aggregateScore(benchmarkScored.scores, field, benchmarkScored.submissions, results)
    })
    return benchmarkScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results for submission.
   */
  static getSubmissionScored(
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
      scores: {},
    }
    // once children are appended and scored, it's safe to aggregate score
    submissionDef.fields.forEach((field) => {
      this.aggregateScore(submissionScored.scores, field, submissionScored.tests, results)
    })
    return submissionScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results for submission.
   */
  static getTestScored(test: TestDefinition, scenarios: ScenarioDefinition[], results: Result[]): TestScored {
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
      scores: {},
    }
    // once children are appended and scored, it's safe to aggregate score
    test.fields.forEach((field) => {
      this.aggregateScore(testScored.scores, field, testScored.scenarios, results)
    })
    return testScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results for scenario.
   */
  static getScenarioScored(scenario: ScenarioDefinition, results: Result[]): ScenarioScored {
    // build leaf
    const scenarioScored: ScenarioScored = {
      definition: scenario,
      scores: {},
    }
    // once tree is built, it's safe to aggregate score
    scenario.fields.forEach((field) => {
      this.aggregateScore(scenarioScored.scores, field, [], results)
    })
    return scenarioScored
  }

  /**
   * **NOTE:** It's the callers responsibility to filter results.
   */
  static aggregateScore(scores: Scores, field: FieldDefinition, children: { scores?: Scores }[], results: Result[]) {
    // if agg_func is undefined, take first match from results
    if (typeof field.agg_func === 'undefined') {
      const fieldName = this.getInFieldName(field, 0)
      scores[field.out_field] = results.find((result) => result.key === fieldName)?.score ?? null
    }
    // otherwise, aggregate accordingly
    else {
      let values: (number | null)[]
      // collect scores from children matching in_field
      if (!field.agg_lateral) {
        // REMARK: error when number of fields doesn't match number of scores?
        values = children.map((child, index) => {
          const fieldName = this.getInFieldName(field, index)
          return fieldName ? (child.scores?.[fieldName] ?? null) : null
        })
      }
      // collect scores from collected scores matching in_field
      else {
        values = []
        for (let index = 0; index < (Array.isArray(field.in_fields) ? field.in_fields.length : 1); index++) {
          const fieldName = this.getInFieldName(field, index)
          values.push(fieldName ? (scores[fieldName] ?? null) : null)
        }
      }
      // aggregate values
      scores[field.out_field] = this.runAggregation(values, field.agg_func)
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
}
