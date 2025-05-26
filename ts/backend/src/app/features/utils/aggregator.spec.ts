import { beforeAll, describe, expect, it } from 'vitest'
import {
  Aggregator,
  BenchmarkDefinition,
  Result,
  ScenarioDefinition,
  Scoring,
  Scorings,
  Submission,
  TestDefinition,
} from './aggregator.mjs'

// REMARK: following DB scheme here i.o.t. evaluate that

const dummyBenchmarks: BenchmarkDefinition[] = [
  // benchmark "1"
  {
    id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Benchmark 1',
    // REMARK: maybe introduce a SubmissionDefinition interface?
    submission_fields: [
      {
        out_field: 'primary',
        agg_func: 'NANSUM',
        in_fields: 'score',
      },
      {
        out_field: 'secondary',
        agg_func: 'MEAN',
        in_fields: 'score',
      },
      {
        out_field: 'mix',
        agg_func: 'SUM',
        in_fields: ['score', 'done'],
      },
    ],
    // REMARK: normalize FieldDefinitions
    fields: [
      {
        out_field: 'total',
        agg_func: 'NANSUM',
        in_fields: 'primary',
      },
    ],
  },
  // benchmark "2"
  {
    id: '7d9b77bf-1098-4487-aece-e10c1285cb41',
    name: 'Benchmark 2',
    submission_fields: [
      {
        out_field: 'score',
        agg_func: 'NANSUM',
      },
      {
        out_field: 'done',
        agg_func: 'MEAN',
      },
    ],
    fields: [
      {
        out_field: 'score',
        agg_func: 'SUM',
      },
    ],
  },
]

const dummyTests: TestDefinition[] = [
  // benchmark "1", test "1"
  {
    id: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Test 1.1',
    fields: [
      {
        out_field: 'score',
        agg_func: 'SUM',
      },
      {
        out_field: 'duration',
        agg_func: 'MEDIAN',
      },
      {
        out_field: 'done',
        agg_func: 'MEAN',
      },
    ],
  },
  // benchmark "1", test "2"
  {
    id: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Test 1.2',
    fields: [
      {
        out_field: 'score',
        agg_func: 'NANSUM',
      },
      {
        out_field: 'duration',
        agg_func: 'NANMEDIAN',
      },
      {
        out_field: 'done',
        agg_func: 'NANMEAN',
      },
      {
        out_field: 'errors',
        agg_func: 'SUM',
      },
      {
        out_field: 'cost',
        agg_func: 'MEDIAN',
      },
      {
        out_field: 'penalty',
        agg_func: 'MEAN',
      },
    ],
  },
  // benchmark "1", test "3"
  {
    id: '8f018414-b6cb-4973-ac54-34d007999a0e',
    benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Test 1.3',
    fields: [
      {
        out_field: 'score',
        agg_func: 'SUM',
      },
    ],
  },
  // benchmark "2", test "1"
  {
    id: '47a58c93-de8b-49bb-a96f-1e7af0403757',
    benchmark_id: '7d9b77bf-1098-4487-aece-e10c1285cb41',
    name: 'Test 2.1',
    fields: [
      {
        out_field: 'score',
        agg_func: 'SUM',
      },
    ],
  },
]

const dummyScenarios: ScenarioDefinition[] = [
  // benchmark "1", test "1"
  {
    id: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    test_id: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    // benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Scenario 1.1.1',
    description: '10x10 grid, 42 agents',
    // test fallback ordering
    fields: [{ out_field: 'score' }, { out_field: 'duration' }, { out_field: 'done' }],
  },
  {
    id: '4145ca69-d13f-426f-befd-20bd087383ee',
    test_id: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    // benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Scenario 1.1.2',
    description: '20x20 grid, 69 agents',
    // test order
    fields: [
      { out_field: 'score', order: 0 },
      { out_field: 'duration', order: 1 },
      { out_field: 'done', order: 2 },
    ],
  },
  {
    id: '654e402a-63a2-4d67-9578-5b13ec409d76',
    test_id: '97688fbd-5d15-4fbb-adeb-1cea163a326b',
    // benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Scenario 1.1.3',
    description: '30x30 grid, i agents',
    // test order
    fields: [
      { out_field: 'done', order: 2 },
      { out_field: 'score', order: 0 },
      { out_field: 'duration', order: 1 },
    ],
  },
  // benchmark "1", test "2"
  {
    id: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    test_id: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    // benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Scenario 1.2.1',
    description: 'comparing aggregators, 1 agent',
    fields: [
      { out_field: 'score' },
      { out_field: 'duration' },
      { out_field: 'done' },
      { out_field: 'errors' },
      { out_field: 'cost' },
      { out_field: 'penalty' },
    ],
  },
  {
    id: 'a7493cb0-bec0-4670-bcea-a3223b45e482',
    test_id: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    // benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Scenario 1.2.2',
    description: 'comparing aggregators, 2 agents',
    fields: [
      { out_field: 'score' },
      { out_field: 'duration' },
      { out_field: 'done' },
      { out_field: 'errors' },
      { out_field: 'cost' },
      { out_field: 'penalty' },
    ],
  },
  {
    id: 'c971a061-3bc4-4650-976a-46b7577e84d1',
    test_id: 'c0269c9b-5182-4764-96cd-e27a1ccd4643',
    // benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Scenario 1.2.3',
    description: 'comparing aggregators, 3 agents',
    fields: [
      { out_field: 'score' },
      { out_field: 'duration' },
      { out_field: 'done' },
      { out_field: 'errors' },
      { out_field: 'cost' },
      { out_field: 'penalty' },
    ],
  },
  // benchmark "1", test "3"
  {
    id: '2e0df491-ec95-4adc-b30a-1d524b832f0a',
    test_id: '8f018414-b6cb-4973-ac54-34d007999a0e',
    // benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    name: 'Scenario 1.3.1',
    description: 'do not test',
    fields: [{ out_field: 'score' }],
  },
  // benchmark "2", test "1"
  {
    id: 'ccf7c5f8-60d4-4bca-99e6-3a7abed22c37',
    test_id: '47a58c93-de8b-49bb-a96f-1e7af0403757',
    // benchmark_id: '7d9b77bf-1098-4487-aece-e10c1285cb41',
    name: 'Scenario 2.1.1',
    description: '8192x8192 grid, 1 lone agent',
    fields: [{ out_field: 'score' }],
  },
]

const dummySubmissions: Submission[] = [
  // submission "1"
  {
    id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    status: 'SUCCESS',
    benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    description: 'This is a dummy submission',
    tests: ['97688fbd-5d15-4fbb-adeb-1cea163a326b', 'c0269c9b-5182-4764-96cd-e27a1ccd4643'],
    published: false,
  },
  // submission "2"
  {
    id: '7a9b5af6-9604-49f7-9dc2-7be73d80b291',
    status: 'SUCCESS',
    benchmark_id: '7d9b77bf-1098-4487-aece-e10c1285cb41',
    description: 'This is another dummy submission',
    tests: ['47a58c93-de8b-49bb-a96f-1e7af0403757'],
    published: false,
  },
  // submission "3"
  {
    id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    status: 'SUCCESS',
    benchmark_id: '98a4f5c6-d929-4eaa-adab-e81a202ed3dd',
    description: 'This is a third dummy submission',
    tests: ['97688fbd-5d15-4fbb-adeb-1cea163a326b'],
    published: false,
  },
]

const dummyResults: Result[] = [
  // submission "1", scenario "1"
  {
    scenario_id: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 10.0,
  },
  {
    scenario_id: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 7.0,
  },
  {
    scenario_id: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 1.0,
  },
  // submission "1", scenario "2"
  {
    scenario_id: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 20.0,
  },
  {
    scenario_id: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 64.0,
  },
  {
    scenario_id: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 1.0,
  },
  // submission "1", scenario "3"
  {
    scenario_id: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 30.0,
  },
  {
    scenario_id: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 55.0,
  },
  {
    scenario_id: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 0.8,
  },
  // submission "1", scenario "4"
  {
    scenario_id: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'score',
    score: 40.0,
  },
  {
    scenario_id: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'duration',
    score: 8954.2,
  },
  {
    scenario_id: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'done',
    score: 0.1,
  },
  {
    scenario_id: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'errors',
    score: 42,
  },
  {
    scenario_id: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'cost',
    score: 99.95,
  },
  {
    scenario_id: '133636be-47f0-40ce-ac83-ce62ed72bbd8',
    submission_id: '5ccc78a3-c60c-4b52-a995-000650edc49b',
    key: 'penalty',
    score: 5,
  },
  // submission "1", scenarios 5-6 left out to test NaN behavior
  // submission "2", scenario "1"
  {
    scenario_id: 'ccf7c5f8-60d4-4bca-99e6-3a7abed22c37',
    submission_id: '7a9b5af6-9604-49f7-9dc2-7be73d80b291',
    key: 'score',
    score: -2.0,
  },
  // submission "3", scenario "1"
  {
    scenario_id: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'score',
    score: 1.0,
  },
  {
    scenario_id: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'duration',
    score: 2.0,
  },
  {
    scenario_id: 'c142fbd1-3e1d-4ca7-9a21-aeacc9d45ae9',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'done',
    score: 1.0,
  },
  // submission "3", scenario "2"
  {
    scenario_id: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'score',
    score: 2.0,
  },
  {
    scenario_id: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'duration',
    score: 4.0,
  },
  {
    scenario_id: '4145ca69-d13f-426f-befd-20bd087383ee',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'done',
    score: 1.0,
  },
  // submission "3", scenario "3"
  {
    scenario_id: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'score',
    score: 3.0,
  },
  {
    scenario_id: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'duration',
    score: 8.0,
  },
  {
    scenario_id: '654e402a-63a2-4d67-9578-5b13ec409d76',
    submission_id: '12ac0ba9-5e4a-4f4d-9b82-90ded100478f',
    key: 'done',
    score: 1.0,
  },
]

/**
 * Replaces resources of type `definition` by their ID during `JSON.stringify`.
 * @param key Key of property being stringified.
 * @param value Value of property being stringified.
 * @returns Anything stringifyable.
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const ResourceAndScoreReplacer = (key: string, value: any) => {
  if (typeof value === 'object') {
    if (key === 'definition' && 'id' in value) {
      return value.id
    }
  }
  return value
}

describe('Aggregator', () => {
  beforeAll(() => {
    const benchmarkGroup = Aggregator.getBenchmarkGroupScored(
      dummyBenchmarks,
      dummyTests,
      dummyScenarios,
      dummySubmissions,
      dummyResults,
    )
    console.log('Tree structure results:')
    // console.log(JSON.stringify(benchmarkGroup))
    console.log(JSON.stringify(benchmarkGroup, ResourceAndScoreReplacer))
  })

  it('should aggregate everything', () => {
    const benchmarkGroup = Aggregator.getBenchmarkGroupScored(
      dummyBenchmarks,
      dummyTests,
      dummyScenarios,
      dummySubmissions,
      dummyResults,
    )
    // both benchmarks should be included in the group
    expect(benchmarkGroup.benchmarks).toHaveLength(2)
    // benchmark 1 should have 2 submissions, 2 1
    expect(benchmarkGroup.benchmarks[0].submissions).toHaveLength(2)
    expect(benchmarkGroup.benchmarks[1].submissions).toHaveLength(1)
  })

  it('should aggregate specific benchmark submissions (Leaderboard)', () => {
    const benchmark = dummyBenchmarks[0]
    const aggregated = Aggregator.getBenchmarkGroupScored(
      [benchmark],
      dummyTests,
      dummyScenarios,
      dummySubmissions,
      dummyResults,
    )
    console.log('= Leaderboard =')
    // REMARK: this logic is currently in test because it
    // A) filters too much (removes links to related resources for brevity)
    // B) resource schema is not yet defined
    const leaderboard = aggregated.benchmarks[0].submissions.map((submission) => {
      const fields = submission.definition.fields.map((field) => field.out_field)
      const row = {
        rank: submission.scorings[fields[0]]?.rank,
        submission: submission.submission.description,
        score_overall: submission.scorings,
        score_tests: {} as Record<string, Scorings>,
      }
      submission.tests.forEach((test) => {
        row.score_tests[test.definition.id] = test.scorings
      })
      return row
    })
    console.log(JSON.stringify(leaderboard))
    expect(leaderboard).toHaveLength(2)
  })

  it('should aggregate whole benchmark group (Campaign Overview)', () => {
    const aggregated = Aggregator.getBenchmarkGroupScored(
      dummyBenchmarks,
      dummyTests,
      dummyScenarios,
      dummySubmissions,
      dummyResults,
    )
    console.log('= Campaign Overview =')
    // REMARK: this logic is currently in test because it
    // A) filters too much (removes links to related resources for brevity)
    // B) resource schema is not yet defined
    const leaderboard = aggregated.benchmarks.map((benchmark) => {
      const row = {
        benchmark: benchmark.definition.name,
        score: benchmark.scorings,
      }
      return row
    })
    console.log(JSON.stringify(leaderboard))
    expect(leaderboard).toHaveLength(2)
  })

  it('should aggregate benchmark of campaign (Campaign, Benchmark Overview)', () => {
    const benchmark = dummyBenchmarks[0]
    const aggregated = Aggregator.getBenchmarkGroupScored(
      [benchmark],
      dummyTests,
      dummyScenarios,
      dummySubmissions,
      dummyResults,
    )
    console.log('= Campaign, Benchmark Overview =')
    // REMARK: this logic is currently in test because it
    // A) filters too much (removes links to related resources for brevity)
    // B) resource schema is not yet defined
    const tests = dummyTests.filter((test) => test.benchmark_id === benchmark.id)
    const getTestTopSubmission = (test: TestDefinition) => {
      const testBenchmark = aggregated.benchmarks.find((benchmark) => benchmark.definition.id === test.benchmark_id)
      for (const submission of testBenchmark?.submissions ?? []) {
        const t = submission.tests.find((t) => t.definition.id === test.id)
        const fields = test.fields.map((field) => field.out_field)
        // 1st-ranked submission = top submission (not exactly when submissions are tied)
        if (t && t.scorings[fields[0]]?.rank === 1) return submission
      }
    }
    const leaderboard = tests.map((test) => {
      const top_submission = getTestTopSubmission(test)
      const row = {
        test: test.name,
        top_submission: top_submission?.submission.description,
        top_score: top_submission?.scorings,
      }
      return row
    })
    console.log(JSON.stringify(leaderboard))
    expect(leaderboard).toHaveLength(3)
  })

  it('should aggregate test of benchmark (Campaign, Benchmark, Test Leaderboard)', () => {
    const benchmark = dummyBenchmarks[0]
    const test = dummyTests[0]
    const aggregated = Aggregator.getBenchmarkGroupScored(
      [benchmark],
      [test],
      dummyScenarios,
      dummySubmissions,
      dummyResults,
    )
    console.log('= Campaign, Benchmark, Test Leaderboard =')
    // REMARK: this logic is currently in test because it
    // A) filters too much (removes links to related resources for brevity)
    // B) resource schema is not yet defined
    const leaderboard = aggregated.benchmarks[0].submissions.map((submission) => {
      const fields = submission.definition.fields.map((field) => field.out_field)
      const row = {
        rank: submission.scorings[fields[0]]?.rank,
        submission: submission.submission.description,
        score_overall: submission.scorings,
      }
      return row
    })
    console.log(JSON.stringify(leaderboard))
    expect(leaderboard).toHaveLength(2)
  })

  it('should aggregate test of submission (Submission Details)', () => {
    const aggregated = Aggregator.getBenchmarkGroupScored(
      dummyBenchmarks,
      dummyTests,
      dummyScenarios,
      dummySubmissions,
      dummyResults,
    )
    console.log('= Submission Details =')
    // REMARK: this logic is currently in test because it
    // A) filters too much (removes links to related resources for brevity)
    // B) resource schema is not yet defined
    const submission = aggregated.benchmarks[0].submissions[0]
    const leaderboard: { test: string; scenario: string | null; rank: number | null; score: Scoring | null }[] = []
    for (const test of submission.tests) {
      const fields = test.definition.fields.map((field) => field.out_field)
      leaderboard.push({
        test: test.definition.name,
        scenario: null,
        rank: test.scorings[fields[0]]?.rank ?? null,
        score: test.scorings[fields[0]] ?? null,
      })
      for (const scenario of test.scenarios) {
        const fields = test.definition.fields.map((field) => field.out_field)
        leaderboard.push({
          test: test.definition.name,
          scenario: scenario.definition.name,
          rank: scenario.scorings[fields[0]]?.rank ?? null,
          score: scenario.scorings[fields[0]] ?? null,
        })
      }
    }
    console.log(JSON.stringify(leaderboard))
    expect(leaderboard).toHaveLength(8)
  })
})
