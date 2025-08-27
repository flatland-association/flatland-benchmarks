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

export interface BenchmarkPreview extends Resource<'/definitions/benchmarks/'> {
  name: string
  description: string
}

export interface Benchmark extends Resource<'/definitions/benchmarks/'> {
  name: string
  description: string
  docker_image: string
  tests: number[]
}

export interface Test extends Resource<'/definitions/tests/'> {
  name: string
  description: string
}

// TODO: remove
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

// TODO: merge/reduce number of interfaces, find a way to use same interface for transport as for computation

export type AggFunction = 'SUM' | 'NANSUM' | 'MEAN' | 'NANMEAN' | 'MEADIAN' | 'NANMEDIAN'

export interface FieldDefinitionRow extends Resource<'/definitions/fields/'> {
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

export interface ScenarioDefinitionRow extends Resource<'/definitions/scenarios/'> {
  id: string
  name: string
  description: string
  field_ids: string[]
}

export type Loop = 'CLOSED' | 'INTERACTIVE' | 'OFFLINE'

export interface TestDefinitionRow extends Resource<'/definitions/tests/'> {
  id: string
  name: string
  description: string
  field_ids: string[]
  scenario_ids: string[]
  loop: Loop
}

export interface BenchmarkDefinitionRow extends Resource<'/definitions/benchmarks/'> {
  id: string
  name: string
  description: string
  field_ids: string[]
  campaign_field_ids: string[]
  test_ids: string[]
}

export type BenchmarkGroupSetup = 'BENCHMARK' | 'COMPETITION' | 'CAMPAIGN'

export interface BenchmarkGroupDefinitionRow extends Resource<'/definitions/benchmark-groups/'> {
  id: string
  name: string
  description: string
  setup: BenchmarkGroupSetup
  benchmark_ids: string[]
}

export type SubmissionStatus = 'SUBMITTED' | 'RUNNING' | 'SUCCESS' | 'FAILURE'

export interface SubmissionRow extends Resource<'/submissions/'> {
  id: string
  benchmark_id: string
  test_ids: string[]
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
  scenario_id: string
  test_id: string
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

export interface SubmissionScenarioScore {
  scenario_id: string
  scorings: Scorings
}

export interface SubmissionTestScore {
  test_id: string
  scorings: Scorings
  scenario_scorings: SubmissionScenarioScore[]
}

export interface SubmissionScore {
  submission_id: string
  scorings: Scorings
  test_scorings: SubmissionTestScore[]
}

export interface Leaderboard {
  benchmark_id: string
  // TODO: rename property to submissions maybe?
  items: SubmissionScore[]
}

export interface OverviewItem {
  test_id: string
  scorings: Scorings | null
  submission_id: string | null
}

export interface CampaignItemOverview {
  benchmark_id: string
  items: OverviewItem[]
  scorings: Scorings
}

export interface CampaignOverview {
  group_id: string
  items: CampaignItemOverview[]
}
