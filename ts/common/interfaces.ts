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

export interface Submission extends Resource<'/submissions/'> {
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
