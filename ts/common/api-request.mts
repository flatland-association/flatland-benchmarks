/**
 * Common interface for requests from client to backend.
 */
export interface ApiRequest<T = unknown> {
  body: T
}
