import { describe, expect, it } from 'vitest'
import {
  Aggregator,
  BenchmarkDefinition,
  FieldDefinition,
  Result,
  ScenarioDefinition,
  Submission,
  TestDefinition,
} from './aggregator.mjs'

// Starter dummies for your convenience when building test cases.

const dummyFields = {
  fsc1: {
    key: 'primary',
    description: 'Primary score (from evaluator)',
  } satisfies FieldDefinition,
  fsc2: {
    key: 'secondary',
    description: 'Secondary score (from evaluator)',
  } satisfies FieldDefinition,
  ft1: {
    key: 'primary',
    description: 'Primary test score (aggregated)',
    agg_func: 'NANSUM',
  } satisfies FieldDefinition,
  ft2: {
    key: 'secondary',
    description: 'Secondary test score (aggregated)',
    agg_func: 'NANSUM',
  } satisfies FieldDefinition,
  fs1: {
    key: 'primary',
    description: 'Primary submission score (aggregated)',
    agg_func: 'NANSUM',
  } satisfies FieldDefinition,
  fs2: {
    key: 'secondary',
    description: 'Secondary submission score (aggregated)',
    agg_func: 'NANSUM',
  } satisfies FieldDefinition,
}

const dummyScenarios = {
  sc1: {
    id: '1ae61e4f-201b-4e97-a399-5c33fb75c57e',
    name: 'Scenario 1',
    description: '10x10 grid, 10 agents',
    field_definitions: [dummyFields.fsc1, dummyFields.fsc2],
  } satisfies ScenarioDefinition,
  sc2: {
    id: '564ebb54-48f0-4837-8066-b10bb832af9d',
    name: 'Scenario 2',
    description: '10x10 grid, 20 agents',
    field_definitions: [dummyFields.fsc1, dummyFields.fsc2],
  } satisfies ScenarioDefinition,
}

const dummyTests = {
  t1: {
    id: '557d9a00-7e6d-410b-9bca-a017ca7fe3aa',
    name: 'Test 1',
    description: 'Test path finding',
    field_definitions: [dummyFields.ft1, dummyFields.ft2],
    scenario_definitions: [dummyScenarios.sc1, dummyScenarios.sc2],
  } satisfies TestDefinition,
}

const dummyBenchmarks = {
  b1: {
    id: '20ccc7c1-034c-4880-8946-bffc3fed1359',
    name: 'Benchmark 1',
    description: 'Domain X benchmark',
    field_definitions: [dummyFields.fs1, dummyFields.fs2],
    test_definitions: [dummyTests.t1],
    evaluator_data: {},
  } satisfies BenchmarkDefinition,
}

const dummySubmissions = {
  s1: {
    id: 'db5eaa85-3304-4804-b76f-14d23adb5d4c',
    benchmark_definition: dummyBenchmarks['b1'],
    test_definitions: [dummyTests['t1']],
    name: 'Submission 1',
    description: 'Submission 1 for test 1',
    submission_url: '',
    code_repository: null,
    submitted_at: '',
    submitted_by_username: 'Tester',
    submission_status: 'SUCCESS',
    published: true,
  } satisfies Submission,
  s2: {
    id: 'f975db67-d33f-4ff4-861c-e2ef35ebdb6d',
    benchmark_definition: dummyBenchmarks['b1'],
    test_definitions: [dummyTests['t1']],
    name: 'Submission 2',
    description: 'Submission 2 for test 1',
    submission_url: '',
    code_repository: null,
    submitted_at: '',
    submitted_by_username: 'Tester',
    submission_status: 'SUCCESS',
    published: true,
  } satisfies Submission,
}

const dummyResults: Result[] = [
  // results for submission 1
  {
    scenario_definition: dummyScenarios.sc1,
    submission: dummySubmissions.s1,
    key: 'primary',
    value: 100,
  },
  {
    scenario_definition: dummyScenarios.sc2,
    submission: dummySubmissions.s1,
    key: 'primary',
    value: 100,
  },
  // results for submission 2
  {
    scenario_definition: dummyScenarios.sc1,
    submission: dummySubmissions.s2,
    key: 'primary',
    value: 100,
  },
  {
    scenario_definition: dummyScenarios.sc1,
    submission: dummySubmissions.s2,
    key: 'primary',
    value: 50,
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
    if (value && 'id' in value) {
      return value.id
    }
  }
  return value
}

describe('Aggregator', () => {
  // TODO: add functional testing values aggregation func,level, case
  // - for func in SUM, NANSUM etc.
  // - for levels in {scenario->test, test->leadeboard, test->campaign}
  // - for case in with/without nan values

  it('should aggregate scores for a given submission', () => {
    const submission = dummySubmissions.s1
    const submissionScored = Aggregator.getSubmissionScored(
      submission.benchmark_definition,
      submission,
      dummyResults.filter((result) => result.submission === submission),
    )
    console.log('= Submission Score =')
    console.log(JSON.stringify(submissionScored, ResourceAndScoreReplacer))
    // TODO: validate scores
    expect(submissionScored).toBeTruthy()
  })

  it('should build a leaderboard', () => {
    const leaderboard = Aggregator.getLeaderboard(
      dummyBenchmarks.b1,
      [dummySubmissions.s1, dummySubmissions.s2],
      dummyResults,
    )
    console.log('= Leaderboard =')
    console.log(JSON.stringify(leaderboard, ResourceAndScoreReplacer))
    // TODO: validate ranking and scores
    expect(leaderboard).toBeTruthy()
  })

  it('should build a campaign item board', () => {
    const campaign = Aggregator.getCampaignItemScored(
      dummyBenchmarks.b1,
      [dummySubmissions.s1, dummySubmissions.s2],
      dummyResults,
    )
    console.log('= Campaign Item =')
    console.log(JSON.stringify(campaign, ResourceAndScoreReplacer))
    // TODO: validate ranking and scores
    expect(campaign).toBeTruthy()
  })

  // TODO: campaign overview
})
