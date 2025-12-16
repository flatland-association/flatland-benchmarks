// putting everything in one file to minimize cyclic imports

import { Tab } from '../frontend/src/app/components/tabs/tabs.component'

export interface BenchmarkPreview {
  name: string
  description: string
}

export interface Benchmark {
  name: string
  description: string
  docker_image: string
  tests: number[]
}

export interface Test {
  name: string
  description: string
}

export interface PageContents {
  headerImage?: {
    /** Image source relative to `/public/` */
    url: string
    /** Image size, default is `LOGO` */
    size?: 'LOGO' | 'FULL'
  }
  introduction?: string
  tabs?: Tab[]
  cta?: string
}

// TODO: merge/reduce number of interfaces, find a way to use same interface for transport as for computation

export type AggFunction = 'SUM' | 'NANSUM' | 'MEAN' | 'NANMEAN' | 'MEADIAN' | 'NANMEDIAN'

export interface FieldDefinitionRow {
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

export interface ScenarioDefinitionRow {
  id: string
  name: string
  description: string
  field_ids: string[]
}

export type Loop = 'CLOSED' | 'INTERACTIVE' | 'OFFLINE'

export interface TestDefinitionRow {
  id: string
  name: string
  description: string
  field_ids: string[]
  scenario_ids: string[]
  loop: Loop
  queue: string | null
}

export interface BenchmarkDefinitionRow {
  id: string
  name: string
  description: string
  contents: PageContents | null
  field_ids: string[]
  campaign_field_ids: string[]
  test_ids: string[]
  suite_id: string | null
}

export type SuiteSetup = 'DEFAULT' | 'COMPETITION' | 'CAMPAIGN'

export interface SuiteDefinitionRow {
  id: string
  name: string
  description: string
  contents: PageContents | null
  setup: SuiteSetup
  benchmark_ids: string[]
}

export type SubmissionStatus = 'SUBMITTED' | 'RUNNING' | 'SUCCESS' | 'FAILURE'

export interface SubmissionRow {
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

export interface PostTestResultsBody {
  data: {
    scenario_id: string
    scores: Record<string, number>
  }[]
}

export interface Scoring {
  field_id: string
  field_key: string
  score: number | null
  // rank, highest and lowest score will only be populated after scoring,
  // on demand, when it's possible to compare submissions/scoring.
  rank?: number
  // Highest and lowest score are required for UI. Repeating them in every
  // scoring ensures it never gets lost, even when filtering rigorously.
  highest?: number
  lowest?: number
}

export interface SubmissionScenarioScore {
  scenario_id: string
  scorings: Scoring[]
}

export interface SubmissionTestScore {
  test_id: string
  scorings: Scoring[]
  scenario_scorings: SubmissionScenarioScore[]
}

export interface SubmissionScore {
  submission_id: string
  scorings: Scoring[]
  test_scorings: SubmissionTestScore[]
}

export interface Leaderboard {
  benchmark_id: string
  test_id?: string
  // TODO: rename property to submissions maybe?
  items: SubmissionScore[]
}

export interface OverviewItem {
  test_id: string
  scorings: Scoring[] | null
  submission_id: string | null
}

export interface CampaignItemOverview {
  benchmark_id: string
  items: OverviewItem[]
  scorings: Scoring[]
}

export interface CampaignOverview {
  suite_id: string
  items: CampaignItemOverview[]
}

export type AuthRole = 'User' | 'Admin'
