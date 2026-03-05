import type { RouteParameters } from 'express-serve-static-core'
import type { AcceptNumberAsString } from './utility-types'

/**
 * Replaces the `:<key>` parts in `endpoint` with corresponding values from `params`.
 * @param endpoint Endpoint name.
 * @param params Object providing the replacement values.
 */
export function interpolateEndpoint(
  endpoint: string,
  params: Record<string, string | number> | AcceptNumberAsString<RouteParameters<string>>,
): string {
  Object.entries(params).forEach(([key, value]) => {
    // replace ':' + key + boundary with interpolated value
    endpoint = endpoint.replace(new RegExp(`:${key}\\b`), `${value}`)
  })
  return endpoint
}
