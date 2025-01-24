// putting everything in one file to minimize cyclic imports

export interface Resource {
  id: number
}

export interface Benchmark extends Resource {
  title: string
  description: string
}
