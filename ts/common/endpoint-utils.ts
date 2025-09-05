import type { RouteParameters } from 'express-serve-static-core'
import { Resource } from './interfaces'
import type {
  AcceptNumberAsString,
  ConsolidatedResourceLocator,
  NotUnion,
  ResourceDir,
  ResourceLocator,
  StripDir,
} from './utility-types'

/**
 * Replaces the `:<key>` parts in `endpoint` with corresponding values from `params`.
 * @param endpoint Endpoint name.
 * @param params Object providing the replacement values.
 */
export function interpolateEndpoint<E extends string>(
  endpoint: E,
  params: AcceptNumberAsString<RouteParameters<E>>,
): string
export function interpolateEndpoint(endpoint: string, params: Record<string, string | number>): string

export function interpolateEndpoint(endpoint: string, params: Record<string, string | number>) {
  Object.entries(params).forEach(([key, value]) => {
    // replace ':' + key + boundary with interpolated value
    endpoint = endpoint.replace(new RegExp(`:${key}\\b`), `${value}`)
  })
  return endpoint
}

/**
 * Turns resources without `dir` into such with `dir`, allowing them to be
 * upcast into specific resources.
 * @param directory A {@link ResourceDir}.
 * @param resources {@link Resource}s to which `dir` should be appended.
 * @returns Copy of resources with `dir` appended.
 */
export function appendDir<Dir extends ResourceDir, T extends Resource<Dir>>(
  directory: Dir,
  resources: StripDir<T>[],
): T[] {
  return resources.map((r) => {
    // prepend the `dir` field, spread rest of resource into it, cast to T
    return {
      dir: directory,
      ...r,
    } as T
  })
}

/**
 * Turns resources into {@link ResourceLocator}s.
 * @param resources {@link Resource}s
 */
export function toResourceLocators<R extends Resource>(resources: R[]): ResourceLocator<R>[] {
  return resources.map((r) => [r.dir, r.id])
}

/**
 * Turns multiple locators into one {@link ConsolidatedResourceLocator}.
 * **Do not pass locators with different `ResourceDir` values!**
 * @param locators {@link ResourceLocator}s
 */
export function consolidateResourceLocator<R extends Resource>(
  locators: ResourceLocator<NotUnion<R>>[],
): ConsolidatedResourceLocator<R> {
  // Generic NotUnion<R> let's us (quite) safely assume locators[0]' dir field
  // is the same for all locators. Unless it's programmatically made a union.
  return [locators[0][0], locators.map((l) => l[1])]
}

/**
 * Turns a locator into a tuple of `[endpoint, params]`, which can be spread
 * directly into API Service functions, e.g. `ApiService.get`.
 * @param locator {@link ResourceLocator} or {@link ConsolidatedResourceLocator}.
 */
export function endpointFromResourceLocator<R extends Resource>(
  locator: ResourceLocator<R> | ConsolidatedResourceLocator<R>,
): [string, { params: { id: string } }] {
  // by contract, locator[0] is the static part of the corresponding endpoint
  const endpoint = `${locator[0]}:id`
  // ids and id are interchangeable in GET requests as per dev.005
  const ids = Array.isArray(locator[1]) ? locator[1] : [locator[1]]
  return [endpoint, { params: { id: ids.join(',') } }]
}
