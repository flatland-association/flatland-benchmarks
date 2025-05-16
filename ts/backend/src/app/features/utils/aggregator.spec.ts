import { beforeAll, describe, expect, it } from 'vitest'
import {
  Aggregator,
  BenchmarkDefinition,
  Result,
  ScenarioDefinition,
  Submission,
  TabularDefinition,
  TabularDefinitionWithResult,
  TestDefinition,
} from './aggregator.mjs'

// REMARK: following DB scheme here i.o.t. evaluate that

const dummyBenchmarks: BenchmarkDefinition[] = [
  // benchmark "1"
  {
    uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    agg_func: 'NANSUM',
    agg_field: 'score',
    view_agg_funcs: ['MEAN'],
    view_agg_fields: ['done'],
  },
  // benchmark "2"
  {
    uuid: '7d9b77bf-1098-4487-aece-e10c1285cb41',
    agg_func: 'NANSUM',
    agg_field: 'score',
    view_agg_funcs: ['MEAN'],
    view_agg_fields: ['done'],
  },
]

const dummyTests: TestDefinition[] = [
  // benchmark "1", test "1"
  {
    uuid: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    agg_func: 'SUM',
    agg_field: 'score',
    view_agg_funcs: ['MEDIAN', 'MEAN'],
    view_agg_fields: ['duration', 'done'],
  },
  // benchmark "1", test "2"
  {
    uuid: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    agg_func: 'NANSUM',
    agg_field: 'score',
    view_agg_funcs: ['NANMEDIAN', 'NANMEAN', 'SUM', 'MEDIAN', 'MEAN'],
    view_agg_fields: ['duration', 'done', 'errors', 'cost', 'penalty'],
  },
  // benchmark "2", test "1"
  {
    uuid: '47a58c93-de8b-49bb-a96f-1e7af0403757',
    benchmark_uuid: '7d9b77bf-1098-4487-aece-e10c1285cb41',
    agg_func: 'SUM',
    agg_field: 'score',
    view_agg_funcs: [],
    view_agg_fields: [],
  },
]

const dummyScenarios: ScenarioDefinition[] = [
  // benchmark "1", test "1"
  {
    uuid: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    test_uuid: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    fields: ['score', 'duration', 'done'],
  },
  {
    uuid: '4145ca69-d13f-426f-befd-20bd087383ee',
    test_uuid: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    fields: ['score', 'duration', 'done'],
  },
  {
    uuid: '654e402a-63a2-4d67-9578-5b13ec409d76',
    test_uuid: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    fields: ['score', 'duration', 'done'],
  },
  // benchmark "1", test "2"
  {
    uuid: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    test_uuid: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    fields: ['score', 'duration', 'done', 'errors', 'cost', 'penalty'],
  },
  {
    uuid: 'a7493cb0-bec0-4670-bcea-a3223b45e482',
    test_uuid: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    fields: ['score', 'duration', 'done', 'errors', 'cost', 'penalty'],
  },
  {
    uuid: 'c971a061-3bc4-4650-976a-46b7577e84d1',
    test_uuid: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    fields: ['score', 'duration', 'done', 'errors', 'cost', 'penalty'],
  },
  // benchmark "2", test "1"
  {
    uuid: 'ccf7c5f8-60d4-4bca-99e6-3a7abed22c37',
    test_uuid: '47a58c93-de8b-49bb-a96f-1e7af0403757',
    benchmark_uuid: '7d9b77bf-1098-4487-aece-e10c1285cb41',
    fields: ['score'],
  },
]

// REMARK: Can scenarios within test have different KPIs? If not, maybe move
// fields definitions up to TestDefinition

const dummySubmissions: Submission[] = [
  // submission "1"
  {
    uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    status: 'SUCCESS',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    description: 'This is a dummy submission',
    published: false,
  },
  // submission "2"
  {
    uuid: '7a9b5af6-9604-49f7-9dc2-7be73d80b291',
    status: 'SUCCESS',
    benchmark_uuid: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    description: 'This is another dummy submission',
    published: false,
  },
]

const dummyResults: Result[] = [
  // submission "1", scenario "1"
  {
    scenario_uuid: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 10.0,
  },
  {
    scenario_uuid: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 7.0,
  },
  {
    scenario_uuid: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 1.0,
  },
  // submission "1", scenario "2"
  {
    scenario_uuid: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 20.0,
  },
  {
    scenario_uuid: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 64.0,
  },
  {
    scenario_uuid: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 1.0,
  },
  // submission "1", scenario "3"
  {
    scenario_uuid: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 30.0,
  },
  {
    scenario_uuid: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 55.0,
  },
  {
    scenario_uuid: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 0.8,
  },
  // submission "1", scenario "4"
  {
    scenario_uuid: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 40.0,
  },
  {
    scenario_uuid: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 8954.2,
  },
  {
    scenario_uuid: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 0.1,
  },
  {
    scenario_uuid: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'errors',
    score: 42,
  },
  {
    scenario_uuid: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'cost',
    score: 99.95,
  },
  {
    scenario_uuid: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_uuid: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'penalty',
    score: 5,
  },
  // submission "1", scenarios 5-6 left out to test NaN behavior
  // submission "2", scenario "1"
  {
    scenario_uuid: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_uuid: '7a9b5af6-9604-49f7-9dc2-7be73d80b291',
    key: 'score',
    score: -2.0,
  },
  {
    scenario_uuid: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_uuid: '7a9b5af6-9604-49f7-9dc2-7be73d80b291',
    key: 'goals',
    score: -1.0,
  },
  {
    scenario_uuid: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_uuid: '7a9b5af6-9604-49f7-9dc2-7be73d80b291',
    key: 'done',
    score: 0.0,
  },
]

// REMARK: Maybe use arrays for key (field) and score in ScenarioDefinition.
// This would minimize the number of Result rows.
// REMARK: Possible to have a Result with some KPIs missing? Isn't it either
// all KPIs evaluated or none?

/**
 * Replaces resources of type `Benchmark`, `Test`, `Scenario` and `Submission`
 * by their UUID and result simply by the numerical score during
 * `JSON.stringify`.
 * @param key Key of property being stringified.
 * @param value Value of property being stringified.
 * @returns Anything stringifyable.
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const ResourceAndScoreReplacer = (key: string, value: any) => {
  if (typeof value === 'object') {
    if ((key === 'benchmark' || key === 'test' || key === 'scenario' || key === 'submission') && 'uuid' in value) {
      return value.uuid
    } else if (key === 'result' && 'score' in value) {
      return value.score
    }
  }
  return value
}

describe('Aggregator', () => {
  let tabularDefinitions: TabularDefinition
  let tabularResults: TabularDefinitionWithResult

  beforeAll(() => {
    tabularDefinitions = Aggregator.joinDefinitions(dummyBenchmarks, dummyTests, dummyScenarios)
    console.log('Tabular structure definitions:')
    console.log(JSON.stringify(tabularDefinitions, ResourceAndScoreReplacer))
    tabularResults = Aggregator.joinResults(tabularDefinitions, dummySubmissions, dummyResults)
    console.log('Tabular structure results:')
    console.log(JSON.stringify(tabularResults, ResourceAndScoreReplacer))
  })

  it('should fully join definitions', () => {
    // expect 28 rows (one per KPI):
    // 9 in benchmark "1", test "1"
    // 18 in benchmark "1", test "2"
    // 1 in benchmark "2"
    expect(tabularDefinitions).toHaveLength(28)
  })

  it('should fully join results', () => {
    // expect 54 rows:
    // 27 for all KPIs in benchmark "1" for submission "1"
    // 27 for all KPIs in benchmark "1" for submission "2"
    expect(tabularResults).toHaveLength(54)
  })

  it('should aggregate score over test', () => {
    // only consider one submission and one test
    const mySubmission = dummySubmissions[0]
    for (let index = 0; index < dummyTests.length; index++) {
      const test = dummyTests[index]
      const submissionResults = tabularResults.filter((row) => row.submission === mySubmission)
      // REMARK: For test 3, score will be 0 - because that submission wasn't
      // made for the benchmark hosting test 3. What to expect then?
      const testScore = Aggregator.aggregateTestScore(submissionResults, test)
      console.log(`Test score for mySubmission, test ${index + 1}`)
      // REMARK: attention, apparently NaN can't be JSONified, compare:
      console.log(JSON.stringify(testScore))
      console.log(testScore)
      // REMARK: Since NaN is null in JSON - use null instead of NaN?
    }
  })
})
