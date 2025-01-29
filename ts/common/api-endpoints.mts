import { ApiRequest } from './api-request.mjs'
import { ApiResponse } from './api-response.mjs'
import { Benchmark, Submission, Test } from './interfaces.mjs'
import { Empty, json, ResourceId, ResourceLocator, StripLocator } from './utility-types.mjs'

/**
 * Base interface for registered API endpoints.
 * @param Request Type of request body. Use `Empty` to indicate absence.
 * @param Response Type of response body. Use `null` or `Empty` to indicate absence.
 */
export interface ApiEndpoint<Request, Response> {
  request: ApiRequest<Request>
  response: ApiResponse<Response>
}

// TODO: remove above, clone below for POST

export interface ApiGetEndpoint<Query, Response> {
  request: ApiRequest<Empty, Query>
  response: ApiResponse<Response>
}

/**
 * Registered API endpoints for GET method.
 * Pairs of `path : ApiEndpoint<Request, Response>` with `path` being a string
 * starting with `/`. Use `:<name>` syntax to set up named parameters.
 * @see {@link ApiEndpoint}
 */
export interface ApiGetEndpoints {
  '/mirror': ApiGetEndpoint<Empty, string>
  '/mirror/:id': ApiGetEndpoint<Empty, string>
  '/dbsetup': ApiGetEndpoint<Empty, unknown>
  '/ampq': ApiGetEndpoint<Empty, string>
  '/benchmarks': ApiGetEndpoint<Empty, ResourceLocator<Benchmark>[]> // dev.001
  '/benchmarks/:id': ApiGetEndpoint<Empty, Benchmark[]> // [] - dev.002
  '/tests/:id': ApiGetEndpoint<Empty, Test[]> // [] - dev.002
  '/submissions': ApiGetEndpoint<{ benchmark?: ResourceId }, ResourceLocator<Submission>[]>
  '/submissions/:id': ApiGetEndpoint<Empty, Submission[]>
  '/submissions/:id/results': ApiGetEndpoint<Empty, unknown>
  '/test': ApiGetEndpoint<Empty, Empty>
}

/**
 * Registered API endpoints for POST method.
 * @see {@link ApiGetEndpoints} for syntax.
 */
export interface ApiPostEndpoints {
  '/mirror': ApiEndpoint<{ data: unknown }, unknown>
  '/ampq': ApiEndpoint<json, string>
  '/submissions': ApiEndpoint<StripLocator<Submission>, { id: ResourceId }>
}
