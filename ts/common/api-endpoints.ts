import { ApiRequest } from './api-request'
import { ApiResponse } from './api-response'
import {
  Benchmark,
  BenchmarkPreview,
  PostTestResultsBody,
  Result,
  SubmissionPreview,
  SubmissionRow,
  Test,
} from './interfaces'
import { Empty, json, NoNever, ResourceId, StripLocator } from './utility-types'

/**
 * Interface for registered enpoints. Types the request body, request query
 * and response.
 */
interface ApiEndpoint<Body = unknown, Query = unknown, Response = unknown> {
  request: ApiRequest<Body, Query>
  response: ApiResponse<Response>
}

/**
 * Registered endpoints per verb.
 * Pairs of `Verb : ApiEndpoint`.
 * @see {@link ApiEndpoint}
 */
interface ApiEndpointVerbs {
  GET?: ApiEndpoint
  POST?: ApiEndpoint
  PATCH?: ApiEndpoint
}

// There is no way in TypeScript to enforce the types of an interface's
// properties a priori - instead, give dev freedom to make mistakes and filter
// those endpoints that actually match the `path: ApiEndpointVerbs` pattern
// below (see ApiEndpoints below), otherwise any mistake in the definitions
// would cause hard-to-track-down type errors in controllers.
/**
 * Registered API endpoints.
 * Pairs of `path : ApiEndpointVerbs` with `path` being a string starting with
 * `/`. Use `:<name>` syntax to set up named parameters.
 * @see {@link ApiEndpointVerbs}
 * @see {@link ApiEndpoint}
 */
interface ApiEndpointDefinitions {
  '/mirror': {
    GET: ApiEndpoint<Empty, Empty, string>
    POST: ApiEndpoint<{ data: json }, Empty, { data: json }>
  }
  '/mirror/:id': {
    GET: ApiEndpoint<Empty, Empty, string>
    PATCH: ApiEndpoint<{ data: json }, Empty, { data: json }>
  }
  '/dbsetup': {
    GET: ApiEndpoint<Empty, Empty, null>
  }
  '/amqp': {
    GET: ApiEndpoint<Empty, Empty, string>
    POST: ApiEndpoint<json, Empty, string>
  }
  '/whoami': {
    GET: ApiEndpoint<Empty, Empty, json>
  }
  '/benchmarks': {
    GET: ApiEndpoint<Empty, Empty, BenchmarkPreview[]>
  }
  '/benchmarks/:id': {
    GET: ApiEndpoint<Empty, Empty, Benchmark[]>
  }
  '/tests/:id': {
    GET: ApiEndpoint<Empty, Empty, Test[]>
  }
  '/submissions': {
    GET: ApiEndpoint<Empty, { benchmark?: ResourceId; uuid?: string; submitted_by?: string }, SubmissionPreview[]>
    POST: ApiEndpoint<StripLocator<SubmissionRow>, Empty, { id: string }>
  }
  '/submissions/:uuid': {
    GET: ApiEndpoint<Empty, Empty, SubmissionRow[]>
  }
  '/submissions/:uuid/results': {
    GET: ApiEndpoint<Empty, Empty, Result[]>
  }
  '/test': {
    GET: ApiEndpoint<Empty, Empty, Test>
  }
  '/result': {
    PATCH: ApiEndpoint<Partial<Result>, Empty, Result>
  }
  '/results/submission/:submission_id/tests/:test_id': {
    GET: ApiEndpoint<Empty, Empty, json>
    POST: ApiEndpoint<PostTestResultsBody, Empty, boolean>
  }
}

/**
 * Type-saved version of `ApiEndpointDefinitions` with all non-conforming defs
 * removed.
 */
export type ApiEndpoints = NoNever<{
  [E in keyof ApiEndpointDefinitions]: ApiEndpointDefinitions[E] extends ApiEndpointVerbs
    ? ApiEndpointDefinitions[E]
    : never
}>

/**
 * Registered API endpoints for given method.
 * Extracted from `ApiEndpoints`
 * @see {@link ApiEndpoints}
 */
export type ApiEndpointsOfVerb<V extends string> = NoNever<{
  [EP in keyof ApiEndpoints]: ApiEndpoints[EP] extends Record<V, ApiEndpoint> ? ApiEndpoints[EP][V] : never
}>

/**
 * Registered API endpoints for GET method.
 * Extracted from `ApiEndpoints`
 * @see {@link ApiEndpoints}
 */
export type ApiGetEndpoints = ApiEndpointsOfVerb<'GET'>

/**
 * Registered API endpoints for POST method.
 * Extracted from `ApiEndpoints`
 * @see {@link ApiEndpoints}
 */
export type ApiPostEndpoints = ApiEndpointsOfVerb<'POST'>

/**
 * Registered API endpoints for PATCH method.
 * Extracted from `ApiEndpoints`
 * @see {@link ApiEndpoints}
 */
export type ApiPatchEndpoints = ApiEndpointsOfVerb<'PATCH'>
