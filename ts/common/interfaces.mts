// putting everything in one file to minimize cyclic imports

import { ResourceDir, ResourceId } from './utility-types.mjs'

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
  tests: number[]
}

export interface Test extends Resource<'/tests/'> {
  name: string
  description: string
}

export interface SubmissionPreview extends Resource<'/submissions/'> {
  benchmark: ResourceId
  submitted_at: string
  submitted_by_username: string
  scores: number[]
}

export interface Submission extends Resource<'/submissions/'> {
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
