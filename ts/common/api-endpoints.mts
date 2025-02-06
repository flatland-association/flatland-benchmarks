import { ApiRequest } from './api-request.mjs'
import { ApiResponse } from './api-response.mjs'
import { Benchmark, Result, Submission, Test } from './interfaces.mjs'
import { Empty, json, ResourceId, ResourceLocator, StripLocator } from './utility-types.mjs'

/**
 * Base interface for registered API GET endpoints.
 * @param Query Type of request query. Use `Empty` to indicate absence.
 * @param Response Type of response body. Use `null` or `Empty` to indicate absence.
 */
export interface ApiGetEndpoint<Query, Response> {
  request: ApiRequest<Empty, Query>
  response: ApiResponse<Response>
}

/**
 * Base interface for registered API POST endpoints.
 * @param Body Type of request body. Use `Empty` to indicate absence.
 * @param Response Type of response body. Use `null` or `Empty` to indicate absence.
 */
export interface ApiPostEndpoint<Body, Response> {
  request: ApiRequest<Body, Empty>
  response: ApiResponse<Response>
}

/**
 * Base interface for registered API PATCh endpoints.
 * @param Body Type of request body. Use `Empty` to indicate absence.
 * @param Response Type of response body. Use `null` or `Empty` to indicate absence.
 */
export interface ApiPatchEndpoint<Body, Response> {
  request: ApiRequest<Body, Empty>
  response: ApiResponse<Response>
}

/**
 * Registered API endpoints for GET method.
 * Pairs of `path : ApiGetEndpoint<Query, Response>` with `path` being a string
 * starting with `/`. Use `:<name>` syntax to set up named parameters.
 * @see {@link ApiGetEndpoint}
 */
// list endpoints return locators instead of full resources - dev.001
// resource endpoints always return an array of said resource - dev.002
export interface ApiGetEndpoints {
  '/mirror': ApiGetEndpoint<Empty, string>
  '/mirror/:id': ApiGetEndpoint<Empty, string>
  '/dbsetup': ApiGetEndpoint<Empty, unknown>
  '/ampq': ApiGetEndpoint<Empty, string>
  '/whoami': ApiGetEndpoint<Empty, json>
  '/benchmarks': ApiGetEndpoint<Empty, ResourceLocator<Benchmark>[]>
  '/benchmarks/:id': ApiGetEndpoint<Empty, Benchmark[]>
  '/tests/:id': ApiGetEndpoint<Empty, Test[]>
  '/submissions': ApiGetEndpoint<{ benchmark?: ResourceId }, ResourceLocator<Submission>[]>
  '/submissions/:id': ApiGetEndpoint<Empty, Submission[]>
  '/submissions/:id/results': ApiGetEndpoint<Empty, Result[]>
  '/test': ApiGetEndpoint<Empty, Empty>
}

/**
 * Registered API endpoints for POST method.
 * Pairs of `path : ApiPostEndpoint<Body, Response>` with `path` being a string
 * starting with `/`. Use `:<name>` syntax to set up named parameters.
 * @see {@link ApiPostEndpoint} for syntax.
 */
export interface ApiPostEndpoints {
  '/mirror': ApiPostEndpoint<{ data: unknown }, unknown>
  '/ampq': ApiPostEndpoint<json, string>
  '/submissions': ApiPostEndpoint<StripLocator<Submission>, { id: ResourceId }>
}

/**
 * Registered API endpoints for PATCH method.
 * Pairs of `path : ApiPatchEndpoint<Body, Response>` with `path` being a string
 * starting with `/`. Use `:<name>` syntax to set up named parameters.
 * @see {@link ApiPostEndpoint} for syntax.
 */
export interface ApiPatchEndpoints {
  '/result': ApiPostEndpoint<Partial<Result>, Result>
}
