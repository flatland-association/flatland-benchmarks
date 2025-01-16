/**
 * Common interface for responses from backend to client.
 */
export interface ApiResponse<T> {
  body?: T
  error?: {
    text: string
  }
  dbg?: unknown
}
