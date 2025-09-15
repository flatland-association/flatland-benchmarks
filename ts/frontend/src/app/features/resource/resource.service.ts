import { inject, Injectable } from '@angular/core'
import { ApiGetEndpoints } from '@common/api-endpoints'
import { ApiGetOptions } from '@common/api-types'
import { interpolateEndpoint } from '@common/endpoint-utils'
import { BanEmpty, Empty, OptionalEmpty } from '@common/utility-types'
import { RouteParameters } from 'express-serve-static-core'
import { ApiService } from '../api/api.service'

interface AsyncCacheItem<T> {
  value?: T
  promise: Promise<T>
  promiseResolve: (value: T) => void
  promiseReject: (reason?: unknown) => void
  timestamp?: number
}

// like ApiGetOptions but allowing params to be of type string[]
interface AugmentedApiGetOptions<E extends keyof ApiGetEndpoints> {
  params: {
    [K in keyof RouteParameters<E>]: string | string[]
  }
  query?: ApiGetEndpoints[E]['request']['query']
}

interface RequestDescriptor<E extends keyof ApiGetEndpoints> {
  endpoint: E
  options?: Partial<AugmentedApiGetOptions<E>>
}

// TODO: ideally define where endpoints are defined
// see: https://github.com/flatland-association/flatland-benchmarks/issues/413
const maxAges: Partial<Record<keyof ApiGetEndpoints, number>> = {
  '/results/benchmarks/:benchmark_id/tests/:test_ids': 0,
  '/results/benchmarks/:benchmark_ids': 0,
  '/results/campaign-items/:benchmark_ids': 0,
  '/results/campaigns/:suite_ids': 0,
  '/results/submissions/:submission_id/scenario/:scenario_ids': 0,
  '/results/submissions/:submission_id/tests/:test_ids': 0,
  '/results/submissions/:submission_ids': 0,
}

@Injectable({
  providedIn: 'root',
})
export class ResourceService {
  private apiService = inject(ApiService)

  // maps "resource identifier" (interpolated endpoint + query params) to response
  private cache = new Map<string, AsyncCacheItem<unknown>>()

  // NOTE: The `& {}` you see in types below is to pretty print the type (makes
  // debugging type errors easier, as it resolves generics where possible)

  /**
   * Load resource from cache or backend, if not cached yet.
   * @param endpoint String representation of the endpoint route.
   * @param _options Request options. Last param can be `string` or `string[]` -
   * if latter, it will be interpreted as list of ids that can be spread for
   * cache lookup but be joined with a comma for the API request.
   * @see {@link ApiGetEndpoints}
   */
  async load<E extends keyof ApiGetEndpoints & {}, O extends OptionalEmpty<AugmentedApiGetOptions<E>>>(
    endpoint: E,
    ..._options: Empty extends O ? [options?: O] : [O & {}]
  ): Promise<ApiGetEndpoints[E]['response']['body']> {
    return this.loadOrdered<E, O>(endpoint, ..._options)
  }

  /**
   * Load resources from cache or backend, if not cached yet.
   * Returned resources are not in order of passed ids.
   * @param endpoint String representation of the endpoint route.
   * @param _options Request options. Last param can be `string` or `string[]` -
   * if latter, it will be interpreted as list of ids that can be spread for
   * cache lookup but be joined with a comma for the API request.
   * @see {@link ApiGetEndpoints}
   */
  async loadGrouped<E extends keyof ApiGetEndpoints & {}, O extends OptionalEmpty<AugmentedApiGetOptions<E>>>(
    endpoint: E,
    ..._options: Empty extends O ? [o?: O] : [o: O & {}]
  ): Promise<ApiGetEndpoints[E]['response']['body']> {
    const options = _options[0]
    // Group (make unique) all entries in array params
    for (const key in options?.params) {
      if (Array.isArray(options.params[key])) {
        options.params[key] = [...new Set(options.params[key])]
      }
    }
    return this.loadOrdered<E, O>(endpoint, ..._options)
  }

  /**
   * Load multiple resources from cache or backend, if not cached yet.
   * Returned resources are in order of passed ids.
   * @param endpoint String representation of the endpoint route.
   * @param _options Request options. Last param can be `string` or `string[]` -
   * if latter, it will be interpreted as list of ids that can be spread for
   * cache lookup but be joined with a comma for the API request.
   * @see {@link ApiGetEndpoints}
   */
  async loadOrdered<E extends keyof ApiGetEndpoints & {}, O extends OptionalEmpty<AugmentedApiGetOptions<E>>>(
    endpoint: E,
    ..._options: Empty extends O ? [o?: O] : [o: O & {}]
  ): Promise<ApiGetEndpoints[E]['response']['body']> {
    const options = _options[0]
    const now = Date.now()
    const maxAge = maxAges[endpoint]
    const tcutoff = typeof maxAge !== 'undefined' ? now - maxAge : undefined

    let resourceRequests: RequestDescriptor<E>[]

    // accept at max one spread param - derive that one from options (last
    // listed array is spread param)
    let spread: keyof RouteParameters<E> | undefined
    if (options?.params) {
      Object.entries(options.params).forEach(([param, value]) => {
        if (Array.isArray(value)) {
          spread = param as keyof RouteParameters<E>
        }
      })
      //... all other array params: collapse
      for (const key in options.params) {
        if (key !== spread && Array.isArray(options.params[key])) {
          options.params[key] = options.params[key].join(',')
        }
      }
    }

    // If spread params are passed, interpolate endpoint with options merged
    // with entry for every spread param. For that to work, clone options and
    // overwrite the id param for every request.
    // Without spreading, simply use original options for interpolation.
    if (spread) {
      resourceRequests = (options!.params![spread] as string[]).map((id) => {
        return { endpoint, options: this.cloneOptionsForId(options, spread!, id) }
      })
    } else {
      resourceRequests = [{ endpoint, options }]
    }

    const apiRequests: RequestDescriptor<E>[] = []

    // go through all resource requests (in order) and either
    // - return cached promise
    // - prepare + return cached promise, make api request and resolve later on
    const promises = resourceRequests.map((request) => {
      const identifier = this.getResourceIdentifier(request.endpoint, request.options)
      const item = this.cache.get(identifier)
      if (
        item &&
        (typeof item.timestamp === 'undefined' || typeof tcutoff === 'undefined' || item.timestamp >= tcutoff)
      ) {
        // this returns the same promise if the same id is duplicated in `ids`
        return item.promise
      } else {
        // create the cache item (with promise and executor) once
        const cacheItem = {} as AsyncCacheItem<ApiGetEndpoints[E]['response']['body']>
        cacheItem.promise = new Promise<ApiGetEndpoints[E]['response']['body']>((resolve, reject) => {
          cacheItem.promiseResolve = resolve
          cacheItem.promiseReject = reject
        }).then((value) => {
          // start item lifetime only once it has been resolved
          cacheItem.timestamp = now
          cacheItem.value = value
          return value
        })
        //@ts-expect-error subtype
        this.cache.set(identifier, cacheItem)
        // and remember to load once
        apiRequests.push(request)
        return cacheItem.promise
      }
    })

    // Make actual API request - deliberately using the singular here, as per
    // - function signature, all requested resources are of same type
    // - dev.005, same-type GET requests can be pooled with comma separated ids
    // which leads to the conclusion that all remaining requests can be merged
    // into one. (And also: if there are actually multiple requests, they only
    // differ by the id param)
    if (apiRequests.length > 0) {
      const actualRequest = window.structuredClone(apiRequests[0])
      // merge request if necessary
      if (apiRequests.length > 1) {
        const actualIds = apiRequests.map((request) => request.options!.params![spread!])
        actualRequest.options!.params![spread!] = actualIds.join(',')
      }
      const body = (
        await this.apiService.get(actualRequest.endpoint, actualRequest.options as BanEmpty<ApiGetOptions<E>>)
      ).body
      const resources = Array.isArray(body) ? body : [body]
      // go through all loaded resources and resolve the cached promise
      resources?.forEach((resource) => {
        // The returned resource does not include the complete identifier,
        // hence rebuild that from request merged with response id.
        const resourceEndpoint = actualRequest.endpoint
        let resourceOptions = actualRequest.options
        if (spread) {
          resourceOptions = this.cloneOptionsForId(resourceOptions, spread, resource.id)
        }
        const identifier = this.getResourceIdentifier(resourceEndpoint, resourceOptions)
        const item = this.cache.get(identifier)
        item?.promiseResolve(resource)
      })
    }
    // @ ts-expect-error type
    return Promise.all(promises)
  }

  /**
   * Returns a copy of a `AugmentedApiGetOptions` object with the specified
   * `param` (from `options.params`) replaced by `id`.
   */
  private cloneOptionsForId<E extends keyof ApiGetEndpoints & {}>(
    options: Partial<AugmentedApiGetOptions<E>> | undefined,
    param: keyof RouteParameters<E>,
    id: string,
  ) {
    const opts = (window.structuredClone(options) ?? {}) as Partial<AugmentedApiGetOptions<E>>
    opts.params ??= {} as AugmentedApiGetOptions<E>['params']
    opts.params[param] = id
    return opts
  }

  /**
   * Returns a resource identifier, which is derived from its endpoint (with
   * interpolated parameters) and optional query.
   */
  private getResourceIdentifier<E extends keyof ApiGetEndpoints & {}, O extends Partial<AugmentedApiGetOptions<E>>>(
    endpoint: E,
    options?: O | undefined,
  ) {
    if (!options?.query) {
      return interpolateEndpoint(endpoint, (options?.params ?? {}) as RouteParameters<E>)
    } else {
      return (
        interpolateEndpoint(endpoint, (options?.params ?? {}) as RouteParameters<E>) + JSON.stringify(options.query)
      )
    }
  }
}
