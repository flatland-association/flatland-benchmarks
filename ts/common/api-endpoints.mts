import { ApiRequest } from './api-request.mjs'
import { ApiResponse } from './api-response.mjs'

/**
 * Base interface for registered API endpoints.
 * @param Request Type of request body. Use `null` to indicate absence.
 * @param Response Type of response body. Use `null` to indicate absence.
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
  '/mirror': ApiEndpoint<null, string>
  '/mirror/:id': ApiEndpoint<null, string>
  '/dbsetup': ApiEndpoint<null, unknown>
  '/ampq': ApiEndpoint<null, string>
  '/submissions': ApiEndpoint<null, unknown>
  '/submissions/:id': ApiEndpoint<null, unknown>
}

/**
 * Registered API endpoints for POST method.
 * @see {@link ApiGetEndpoints} for syntax.
 */
export interface ApiPostEndpoints {
  '/mirror': ApiEndpoint<{ data: unknown }, unknown>
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  '/ampq': ApiEndpoint<any, string>
  '/submissions': ApiEndpoint<{ submission_image: string }, { id: number }>
}
