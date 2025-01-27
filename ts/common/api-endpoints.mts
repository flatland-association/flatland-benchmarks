import { ApiRequest } from './api-request.mjs'
import { ApiResponse } from './api-response.mjs'
import { Benchmark } from './interfaces.mjs'
import { Empty, json } from './utility-types.mjs'

/**
 * Base interface for registered API endpoints.
 * @param Request Type of request body. Use `Empty` to indicate absence.
 * @param Response Type of response body. Use `null` or `Empty` to indicate absence.
 */
export interface ApiEndpoint<Request, Response> {
  request: ApiRequest<Request>
  response: ApiResponse<Response>
}

/**
 * Registered API endpoints for GET method.
 * Pairs of `path : ApiEndpoint<Request, Response>` with `path` being a string
 * starting with `/`. Use `:<name>` syntax to set up named parameters.
 * @see {@link ApiEndpoint}
 */
export interface ApiGetEndpoints {
  '/mirror': ApiEndpoint<Empty, string>
  '/mirror/:id': ApiEndpoint<Empty, string>
  '/dbsetup': ApiEndpoint<Empty, unknown>
  '/ampq': ApiEndpoint<Empty, string>
  '/benchmarks': ApiEndpoint<Empty, string[]> // string[] - dev.001
  '/benchmarks/:id': ApiEndpoint<Empty, Benchmark[]> // [] - dev.002
  '/submissions': ApiEndpoint<Empty, unknown>
  '/submissions/:id': ApiEndpoint<Empty, unknown>
  '/test': ApiEndpoint<Empty, Empty>
}

/**
 * Registered API endpoints for POST method.
 * @see {@link ApiGetEndpoints} for syntax.
 */
export interface ApiPostEndpoints {
  '/mirror': ApiEndpoint<{ data: unknown }, unknown>
  '/ampq': ApiEndpoint<json, string>
  '/submissions': ApiEndpoint<{ submission_image: string }, { id: number }>
}
