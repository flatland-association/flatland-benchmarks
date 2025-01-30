import type { RouteParameters } from 'express-serve-static-core'
import { ApiGetEndpoints, ApiPostEndpoints } from './api-endpoints.mjs'

export interface ApiGetOptions<E extends keyof ApiGetEndpoints> {
  params: RouteParameters<E>
  query?: ApiGetEndpoints[E]['request']['query']
}

export interface ApiPostOptions<E extends keyof ApiPostEndpoints> {
  params: RouteParameters<E>
  body: ApiPostEndpoints[E]['request']['body']
}

// TODO: consolidate other api-types in this file
