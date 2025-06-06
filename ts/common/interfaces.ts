// putting everything in one file to minimize cyclic imports

import { ResourceDir, ResourceId } from './utility-types'

export interface Resource<Dir extends ResourceDir = ResourceDir> {
  /** Directory in which the resource lies. Identifies its type. */
  dir: Dir
  /** Identifier of resource within its directory. */
  id: ResourceId
  /** Resource UUID */
  uuid?: string
}

export interface BenchmarkPreview extends Resource<'/benchmarks/'> {
  name: string
  description: string
}

export interface Benchmark extends Resource<'/benchmarks/'> {
  name: string
  description: string
  docker_image: string
  tests: number[]
}

export interface Test extends Resource<'/tests/'> {
  name: string
  description: string
}

export interface SubmissionPreview extends Resource<'/submissions/'> {
  name: string
  benchmark: ResourceId
  submitted_at: string
  submitted_by_username: string
  public: boolean
  scores: number[]
  rank: number | null
}

// TODO: remove
export interface Submission_old extends Resource<'/submissions/'> {
  name: string
  benchmark: ResourceId
  submission_image: string
  code_repository: string
  tests: ResourceId[]
}

export interface Result extends Resource<'/results/'> {
  submission: ResourceId
  done_at: string | null
  success: boolean | null
  scores: number[] | null
  results_str: string | null
  public: boolean | null
}

// TODO: merge/reduce number of interfaces, find a way to use same interface for transport as for computation

export type AggFunction = 'SUM' | 'NANSUM' | 'MEAN' | 'NANMEAN' | 'MEADIAN' | 'NANMEDIAN'

export interface FieldDefinitionRow extends Resource<'/fields/'> {
  id: string
  /** Identifier of field, how it's accessed in aggregation. */
  key: string
  /** Description of field, used in UI. */
  description: string
  /**
   * Aggregation function to use for aggregated fields (optional, if undefined
   * the field score is taken from the table directly)
   */
  agg_func?: AggFunction | null
  agg_fields?: string | string[] | null
  agg_weights?: number[] | null
  agg_lateral?: boolean | null
}

export interface ScenarioDefinitionRow extends Resource<'/scenarios/'> {
  id: string
  name: string
  description: string
  field_definition_ids: string[]
}

export interface TestDefinitionRow extends Resource<'/tests/'> {
  id: string
  name: string
  description: string
  field_definition_ids: string[]
  scenario_definition_ids: string[]
}

export interface BenchmarkDefinitionRow extends Resource<'/benchmarks/'> {
  id: string
  name: string
  description: string
  field_definition_ids: string[]
  test_definition_ids: string[]
}

export type SubmissionStatus = 'SUBMITTED' | 'RUNNING' | 'SUCCESS' | 'FAILURE'

export interface SubmissionRow extends Resource<'/submissions/'> {
  id: string
  benchmark_definition_id: string
  test_definition_ids: string[]
  name: string
  description?: string | null
  submission_data_url: string
  code_repository?: string | null
  submitted_at?: string | null
  submitted_by?: string | null
  submitted_by_username?: string | null
  status?: SubmissionStatus
  published?: boolean
}

export interface ResultRow {
  scenario_definition_id: string
  test_definition_id: string
  submission_id: string
  key: string
  value: number
}

// TODO: merge with resource pattern, find a way to use same interface for transport as for computation
export interface PostTestResultsBody {
  data: ({
    scenario_id: string
  } & Record<string, number>)[]
}

export interface Scoring {
  score: number | null
  // rank, highest and lowest score will only be populated after scoring,
  // on demand, when it's possible to compare submissions/scoring.
  rank?: number
  // Highest and lowest score are required for UI. Repeating them in every
  // scoring ensures it never gets lost, even when filtering rigorously.
  highest?: number
  lowest?: number
}

// TODO: naming?
export type Scorings = Record<string, Scoring | null>

export interface ScenarioScored {
  scenario_id: string
  scorings: Scorings
}

export interface TestScored {
  test_id: string
  scorings: Scorings
  scenario_scorings: ScenarioScored[]
}

export interface LeaderboardItem {
  submission_id: string
  scorings: Scorings
  test_scorings: TestScored[]
}

export interface Leaderboard {
  benchmark_id: string
  items: LeaderboardItem[]
}

export interface CampaignItemItem {
  test_id: string
  scorings: Scorings | null
  submission_id: string | null
}

export interface CampaignItem {
  benchmark_id: string
  items: CampaignItemItem[]
}
