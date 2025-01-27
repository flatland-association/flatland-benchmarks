// putting everything in one file to minimize cyclic imports

export interface Resource {
  id: number
}

export interface Benchmark extends Resource {
  name: string
  description: string
  tests: number[]
}

export interface Test extends Resource {
  name: string
  description: string
}

export interface Submission extends Resource {
  benchmark: number
  submission_image: string
  code_repository: string
  tests: number[]
}
