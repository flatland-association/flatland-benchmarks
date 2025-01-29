import type { RouteParameters } from 'express-serve-static-core'
import { ApiGetEndpoints } from './api-endpoints.mjs'

export interface ApiGetOptions<E extends keyof ApiGetEndpoints, Q> {
  params: RouteParameters<E>
  query?: Q
}

// TODO: consolidate other api-types in this file
