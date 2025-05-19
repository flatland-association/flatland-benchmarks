// TODO: move interfaces to common and merge with common interfaces

export interface ScenarioDefinition {
  uuid: string
  test_uuid: string
  benchmark_uuid: string
  fields: string[]
  // REMARK: missing description
  // REMARK: move fields to test? possibly the same for all scenarios in test
}

export interface TestDefinition {
  uuid: string
  benchmark_uuid: string
  agg_func: string
  agg_field: string
  view_agg_funcs: string[]
  view_agg_fields: string[]
  // REMARK: maybe just two fields:
  // - fields: string[] - the "output" field names
  // - aggregators: json[] - how fields are aggregated, object of
  //   - field: string - name of field from scenario
  //   - func: string - name of aggregation function
  // REMARK: or maybe just one field:
  // - fields: json[] - fields definition:
  //   - field: string - name of field
  //   - aggregation: json[]
  //     - field: string - name of field from scenario
  //     - func: string - name of aggregation function
  // REMARK: can aggregation also happen horizontally? I.e. the primary
  // score of a test is the weighted sum of its secondary scores...
}

export interface BenchmarkDefinition {
  uuid: string
  agg_func: string
  agg_field: string
  view_agg_funcs: string[]
  view_agg_fields: string[]
  // REMARK: see remark in TestDefinition
}

export interface Result {
  scenario_uuid: string
  submission_uuid: string
  key: string
  score: number
}

export interface Submission {
  uuid: string
  status: 'SUBMITTED' | 'RUNNING' | 'SUCCESS' | 'FAILURE'
  benchmark_uuid: string
  description: string
  published: boolean
  // REMARK: needs field describing selected tests
}

// REMARK: For a first iteration, work with a tabular structure instead of a
// tree. This makes filtering more straight-forward.

export interface TabularDefinitionRow {
  benchmark: BenchmarkDefinition
  test: TestDefinition
  scenario: ScenarioDefinition
  field: string
}

export interface TabularDefinitionWithResultRow extends TabularDefinitionRow {
  submission?: Submission
  result?: Result
}

export type TabularDefinition = TabularDefinitionRow[]

export type TabularDefinitionWithResult = TabularDefinitionWithResultRow[]

export class Aggregator {
  static joinDefinitions(benchmarks: BenchmarkDefinition[], tests: TestDefinition[], scenarios: ScenarioDefinition[]) {
    // basically benchmarks LEFT JOIN tests LEFT JOIN scenarios LEFT JOIN KPIs
    // REMARK: is the "LEFT JOIN KPIs" part feasible in SQL? (i.e. left joining
    // an array from a table field as rows)
    const table: TabularDefinition = []
    // traverse all benchmarks
    for (const benchmark of benchmarks) {
      //... in there, all tests of that benchmark
      const benchmarkTests = tests.filter((test) => test.benchmark_uuid === benchmark.uuid)
      for (const test of benchmarkTests) {
        //... in there, all scenarios of that test
        // REMARK: check benchmark_uuid too or is this redundant?
        const testScenarios = scenarios.filter((scenario) => scenario.test_uuid === test.uuid)
        for (const scenario of testScenarios) {
          //... in there, all KPIs of that scenario
          for (const field of scenario.fields) {
            table.push({
              benchmark,
              test,
              scenario,
              field,
            })
          }
        }
      }
    }
    return table
  }

  static joinResults(definitions: TabularDefinition, submissions: Submission[], results: Result[]) {
    // basically submissions LEFT JOIN definitions LEFT JOIN results
    const table: TabularDefinitionWithResult = []
    // traverse all submissions
    for (const submission of submissions) {
      //... in there, all relevant definitions
      const submissionRows = definitions.filter((row) => row.benchmark.uuid === submission.benchmark_uuid)
      for (const row of submissionRows) {
        //... in there, matching result (identified by submission, scenario + field)
        const result = results.find((result) => {
          return (
            result.submission_uuid === submission.uuid &&
            result.scenario_uuid === row.scenario.uuid &&
            result.key === row.field
          )
        })
        table.push({
          ...row,
          submission,
          result,
        })
      }
    }
    return table
  }

  // TODO: aggregateBenchmarkScore

  static aggregateTestScore(table: TabularDefinitionWithResult, test: TestDefinition) {
    // get all rows from table for specified test
    const resultRows = table.filter((row) => row.test === test)
    // aggregate all defined fields in test
    const aggregated: Record<string, number | undefined> = {}
    const field = test.agg_field
    const func = test.agg_func
    aggregated[field] = this.aggregateTestScoreField(resultRows, field, func)
    for (let index = 0; index < test.view_agg_fields.length; index++) {
      const field = test.view_agg_fields[index]
      const func = test.view_agg_funcs[index]
      aggregated[field] = this.aggregateTestScoreField(resultRows, field, func)
    }
    // REMARK: little less code repetition if all KPIs are defined the same way
    return aggregated
  }

  static aggregateTestScoreField(table: TabularDefinitionWithResult, field: string, func: string) {
    // collect scores (missing will be undefined at first, convert to NaN)
    const scores = table.filter((row) => row.field === field).map((row) => row.result?.score ?? Number.NaN)
    return this.runAggregation(scores, func)
  }

  static runAggregation(scores: number[], func: string) {
    switch (func) {
      case 'SUM':
        // empty set defaults to 0
        if (scores.length === 0) return 0
        // sum up
        return scores.reduce((acc, score) => acc + score, 0)
      case 'NANSUM':
        // filter NaN values
        scores = scores.filter((score) => !Number.isNaN(score))
        // empty set defaults to 0
        if (scores.length === 0) return 0
        // sum up
        return scores.reduce((acc, score) => acc + score, 0)
      case 'MEAN':
        // empty set defaults to NaN
        if (scores.length === 0) return Number.NaN
        // mean
        return scores.reduce((acc, score) => acc + score, 0) / scores.length
      case 'NANMEAN':
        // filter NaN values
        scores = scores.filter((score) => !Number.isNaN(score))
        // empty set defaults to NaN
        if (scores.length === 0) return Number.NaN
        // mean
        return scores.reduce((acc, score) => acc + score, 0) / scores.length
      case 'MEDIAN':
        // empty set defaults to NaN
        if (scores.length === 0) return Number.NaN
        // having NaN results in NaN
        if (scores.some((score) => Number.isNaN(score))) return Number.NaN
        // sort scores
        scores.sort((a, b) => a - b)
        // median
        if (scores.length % 2 === 1) {
          const i = (scores.length - 1) / 2
          return scores[i]
        } else {
          const i = (scores.length - 2) / 2
          return (scores[i] + scores[i + 1]) / 2
        }
      case 'NANMEDIAN':
        // filter NaN values
        scores = scores.filter((score) => !Number.isNaN(score))
        // empty set defaults to NaN
        if (scores.length === 0) return Number.NaN
        // sort scores
        scores.sort((a, b) => a - b)
        // median
        if (scores.length % 2 === 1) {
          const i = (scores.length - 1) / 2
          return scores[i]
        } else {
          const i = (scores.length - 2) / 2
          return (scores[i] + scores[i + 1]) / 2
        }
      default:
        return undefined
      // REMARK: undefined or NaN if func is undefined?
    }
  }
}
