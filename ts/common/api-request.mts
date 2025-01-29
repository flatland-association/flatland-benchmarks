/**
 * Common interface for requests from client to backend.
 */
export interface ApiRequest<Body = unknown, Query = unknown> {
  body: Body
  query: Query
}
