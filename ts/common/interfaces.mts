// putting everything in one file to minimize cyclic imports

import { ResourceDir, ResourceId } from './utility-types.mjs'

export interface Resource<Dir extends ResourceDir = ResourceDir> {
  /** Directory in which the resource lies. Identifies its type. */
  dir: Dir
  /** Identifier of resource within its directory. */
  id: ResourceId
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

export interface Submission extends Resource<'/submissions/'> {
  benchmark: ResourceId
  submission_image: string
  code_repository: string
  tests: ResourceId[]
}
