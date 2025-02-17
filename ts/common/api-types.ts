import type { RouteParameters } from 'express-serve-static-core'
import { ApiGetEndpoints, ApiPatchEndpoints, ApiPostEndpoints } from './api-endpoints'

export interface ApiGetOptions<E extends keyof ApiGetEndpoints> {
  params: RouteParameters<E>
  query?: ApiGetEndpoints[E]['request']['query']
}

export interface ApiPostOptions<E extends keyof ApiPostEndpoints> {
  params: RouteParameters<E>
  body: ApiPostEndpoints[E]['request']['body']
}

export interface ApiPatchOptions<E extends keyof ApiPatchEndpoints> {
  params: RouteParameters<E>
  body: ApiPatchEndpoints[E]['request']['body']
}
