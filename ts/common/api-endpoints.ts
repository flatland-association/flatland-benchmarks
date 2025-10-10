import { ApiRequest } from './api-request'
import { ApiResponse } from './api-response'
import {
  BenchmarkDefinitionRow,
  CampaignItemOverview,
  CampaignOverview,
  FieldDefinitionRow,
  Leaderboard,
  PostTestResultsBody,
  ScenarioDefinitionRow,
  SubmissionRow,
  SubmissionScenarioScore,
  SubmissionScore,
  SubmissionTestScore,
  SuiteDefinitionRow,
  Test,
  TestDefinitionRow,
} from './interfaces'
import { Empty, json, NoNever, StripLocator } from './utility-types'

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
  '/health/live': {
    GET: ApiEndpoint<Empty, Empty, json>
  }
  '/info': {
    GET: ApiEndpoint<Empty, Empty, json>
  }
  '/whoami': {
    GET: ApiEndpoint<Empty, Empty, json>
  }
  '/definitions/suites': {
    GET: ApiEndpoint<Empty, Empty, SuiteDefinitionRow[]>
  }
  '/definitions/suites/:suite_ids': {
    GET: ApiEndpoint<Empty, Empty, SuiteDefinitionRow[]>
  }
  '/test': {
    GET: ApiEndpoint<Empty, Empty, Test>
  }
  '/definitions/benchmarks': {
    GET: ApiEndpoint<Empty, Empty, BenchmarkDefinitionRow[]>
  }
  '/definitions/benchmarks/:benchmark_ids': {
    GET: ApiEndpoint<Empty, Empty, BenchmarkDefinitionRow[]>
  }
  '/definitions/tests/:test_ids': {
    GET: ApiEndpoint<Empty, Empty, TestDefinitionRow[]>
  }
  '/definitions/scenarios/:scenario_ids': {
    GET: ApiEndpoint<Empty, Empty, ScenarioDefinitionRow[]>
  }
  '/definitions/fields/:field_ids': {
    GET: ApiEndpoint<Empty, Empty, FieldDefinitionRow[]>
  }
  '/submissions': {
    GET: ApiEndpoint<
      Empty,
      { benchmark_ids?: string; ids?: string; submitted_by?: string; unpublished_own?: string },
      SubmissionRow[]
    >
    POST: ApiEndpoint<StripLocator<SubmissionRow>, Empty, { id: string }>
  }
  '/submissions/:submission_ids': {
    GET: ApiEndpoint<Empty, Empty, SubmissionRow[]>
    PATCH: ApiEndpoint<Empty, Empty, SubmissionRow[]>
  }
  '/results/submissions/:submission_ids': {
    GET: ApiEndpoint<Empty, Empty, SubmissionScore[]>
  }
  '/results/submissions/:submission_id/tests/:test_ids': {
    GET: ApiEndpoint<Empty, Empty, SubmissionTestScore[]>
    POST: ApiEndpoint<PostTestResultsBody, Empty, Empty>
  }
  '/results/submissions/:submission_id/scenarios/:scenario_ids': {
    GET: ApiEndpoint<Empty, Empty, SubmissionScenarioScore[]>
  }
  '/results/benchmarks/:benchmark_ids': {
    GET: ApiEndpoint<Empty, Empty, Leaderboard[]>
  }
  '/results/campaign-items/:benchmark_ids': {
    GET: ApiEndpoint<Empty, Empty, CampaignItemOverview[]>
  }
  '/results/campaigns/:suite_ids': {
    GET: ApiEndpoint<Empty, Empty, CampaignOverview[]>
  }
  '/results/benchmarks/:benchmark_id/tests/:test_ids': {
    GET: ApiEndpoint<Empty, Empty, Leaderboard[]>
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
