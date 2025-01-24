import type { RouteParameters } from 'express-serve-static-core'

/**
 * Replaces the `:<key>` parts in `endpoint` with corresponding values from `params`.
 * @param endpoint Endpoint name.
 * @param params Object providing the replacement values.
 */
export function interpolateEndpoint<E extends string>(endpoint: E, params: RouteParameters<E>): string

export function interpolateEndpoint(endpoint: string, params: Record<string, string>) {
  Object.entries(params).forEach(([key, value]) => {
    // replace ':' + key + boundary with interpolated value
    endpoint = endpoint.replace(new RegExp(`:${key}\\b`), `${value}`)
  })
  return endpoint
}

/**
 * Builds an array of endpoints from `endpoint` for every `params` element.
 * @param endpoint Endpoint name
 * @param params Array of objects providing the replacement values.
 */
export function spreadEndpoints<E extends string>(endpoint: E, params: RouteParameters<E>[]): string[]

export function spreadEndpoints(endpoint: string, params: Record<string, string>[]) {
  return params.map((p) => interpolateEndpoint(endpoint, p))
}
