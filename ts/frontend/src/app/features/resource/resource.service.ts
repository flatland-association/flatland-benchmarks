import { inject, Injectable } from '@angular/core'
import { ApiGetEndpoints } from '@common/api-endpoints'
import { ApiGetOptions } from '@common/api-types'
import { interpolateEndpoint } from '@common/endpoint-utils'
import { MAX_UUIDS_PER_REQUEST, splitArrayIntoChunks } from '@common/utility-functions'
import { BanEmpty, Empty, OptionalEmpty } from '@common/utility-types'
import { RouteParameters } from 'express-serve-static-core'
import { ApiService } from '../api/api.service'

/**
 * Resource endpoints are ApiEndpoints adhering to dev.002 (returning array).
 */
export type ResourceGetEndpoints = {
  [E in keyof ApiGetEndpoints as Required<ApiGetEndpoints[E]['response']>['body'] extends unknown[]
    ? E
    : never]: ApiGetEndpoints[E]
}

interface AsyncCacheItem<T> {
  value?: T
  promise: Promise<T>
  promiseResolve: (value: T) => void
  promiseReject: (reason?: unknown) => void
  timestamp?: number
}

// like ApiGetOptions but allowing params to be of type string[]
interface AugmentedApiGetOptions<E extends keyof ResourceGetEndpoints> {
  params: {
    [K in keyof RouteParameters<E>]: string | string[]
  }
  query?: ResourceGetEndpoints[E]['request']['query']
}

interface RequestDescriptor<E extends keyof ResourceGetEndpoints> {
  endpoint: E
  options?: Partial<AugmentedApiGetOptions<E>>
  resourceURL: string
}

type ResourceProperty<T> = T extends unknown[] ? keyof T[number] : never

/**
 * Resource meta data.
 */
export type ResourceMetaRecords = {
  [K in keyof ResourceGetEndpoints]?: {
    /** Max. cache lifetime in seconds. Default is 0. */
    maxAge?: number
    /**
     * Which parameter - if any - to spread in multi-requests. Per default, no
     * spreading is applied.
     *
     * Spreading describes the operation treating `GET /res/1, GET /res/2,
     * GET /res/3` the same as `GET /res/1,2,3`, allowing resources to be
     * handled individually yet fetched from backend in one request.
     */
    spreadParam?: keyof RouteParameters<K> | undefined
    /**
     * Which property from the returned resource to consider to build the
     * resource URL. Default is `id`.
     */
    idProperty?: ResourceProperty<ResourceGetEndpoints[K]['response']['body']> & {}
  }
}

/**
 * Meta data define how resources - identified by endpoint - are cached and
 * spread.
 * See also {@link ResourceMetaRecords}
 */
export const resourceMeta: ResourceMetaRecords = {
  '/definitions/fields/:field_ids': {
    maxAge: Infinity,
    spreadParam: 'field_ids',
  },
  '/definitions/scenarios/:scenario_ids': {
    maxAge: Infinity,
    spreadParam: 'scenario_ids',
  },
  '/definitions/tests/:test_ids': {
    maxAge: Infinity,
    spreadParam: 'test_ids',
  },
  '/definitions/benchmarks/:benchmark_ids': {
    maxAge: Infinity,
    spreadParam: 'benchmark_ids',
  },
  '/definitions/suites/:suite_ids': {
    maxAge: Infinity,
    spreadParam: 'suite_ids',
  },
  '/submissions/:submission_ids': {
    maxAge: Infinity,
    spreadParam: 'submission_ids',
  },
  '/results/submissions/:submission_ids': {
    spreadParam: 'submission_ids',
    idProperty: 'submission_id',
  },
  '/results/submissions/:submission_id/tests/:test_ids': {
    spreadParam: 'test_ids',
    idProperty: 'test_id',
  },
  '/results/submissions/:submission_id/scenarios/:scenario_ids': {
    spreadParam: 'scenario_ids',
    idProperty: 'scenario_id',
  },
  '/results/benchmarks/:benchmark_ids': {
    spreadParam: 'benchmark_ids',
    idProperty: 'benchmark_id',
  },
  '/results/campaign-items/:benchmark_ids': {
    spreadParam: 'benchmark_ids',
    idProperty: 'benchmark_id',
  },
  '/results/campaigns/:suite_ids': {
    spreadParam: 'suite_ids',
    idProperty: 'suite_id',
  },
  '/results/benchmarks/:benchmark_id/tests/:test_ids': {
    spreadParam: 'test_ids',
    idProperty: 'test_id',
  },
}

@Injectable({
  providedIn: 'root',
})
export class ResourceService {
  private apiService = inject(ApiService)

  // maps endpoint to responded resources
  private cache = new Map<
    string,
    AsyncCacheItem<ResourceGetEndpoints[keyof ResourceGetEndpoints]['response']['body']>
  >()

  constructor() {
    // expose service for debugging purposes
    //@ts-expect-error any
    window['resourceService'] = this
  }

  // NOTE: The `& {}` you see in types below is to pretty print the type (makes
  // debugging type errors easier, as it resolves generics where possible)

  /**
   * Load resource from cache or backend, if not cached yet.
   * @param endpoint String representation of the endpoint route.
   * @param _options Request options.
   * @see {@link ResourceGetEndpoints}
   */
  async load<E extends keyof ResourceGetEndpoints & {}, O extends OptionalEmpty<AugmentedApiGetOptions<E>>>(
    endpoint: E,
    ..._options: Empty extends O ? [options?: O] : [O & {}]
  ): Promise<ResourceGetEndpoints[E]['response']['body']> {
    return this.loadOrdered<E, O>(endpoint, ..._options)
  }

  /**
   * Load resources from cache or backend, if not cached yet.
   * Returned resources are not in order of passed ids.
   * @param endpoint String representation of the endpoint route.
   * @param _options Request options.
   * @see {@link ResourceGetEndpoints}
   */
  async loadGrouped<E extends keyof ResourceGetEndpoints & {}, O extends OptionalEmpty<AugmentedApiGetOptions<E>>>(
    endpoint: E,
    ..._options: Empty extends O ? [o?: O] : [o: O & {}]
  ): Promise<ResourceGetEndpoints[E]['response']['body']> {
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
   * @param _options Request options.
   * @see {@link ResourceGetEndpoints}
   */
  async loadOrdered<E extends keyof ResourceGetEndpoints & {}, O extends OptionalEmpty<AugmentedApiGetOptions<E>>>(
    endpoint: E,
    ..._options: Empty extends O ? [o?: O] : [o: O & {}]
  ): Promise<ResourceGetEndpoints[E]['response']['body']> {
    const options = _options[0]
    const now = Date.now()
    const meta = resourceMeta[endpoint]

    const tcutoff = typeof meta?.maxAge === 'number' ? now - meta.maxAge * 1000 : now
    const spread = meta?.spreadParam

    let resourceRequests: RequestDescriptor<E>[]

    if (options?.params) {
      // collapse all params (except the spread one, which has to be an array)
      for (const key in options.params) {
        if (key === spread && !Array.isArray(options.params[key])) {
          options.params[key] = [options.params[key]]
        } else if (key !== spread && Array.isArray(options.params[key])) {
          options.params[key] = options.params[key].join(',')
        }
      }
    }

    // If spreading is active, make one virtual resource request per spread
    // param. For that to work, clone options and overwrite the id param for
    // every request.
    if (spread) {
      resourceRequests = (options!.params![spread] as string[]).map((id) => {
        const opts = this.cloneOptionsForId(options, spread!, id)
        const resourceURL = this.getResourceURL(endpoint, opts)
        return {
          endpoint,
          options: opts,
          resourceURL,
        }
      })
    }
    // Without spreading, simply use original options for interpolation.
    else {
      resourceRequests = [{ endpoint, options, resourceURL: this.getResourceURL(endpoint, options) }]
    }

    const apiRequests = new Map<string, RequestDescriptor<E>>()

    // go through all resource requests (in order) and either
    // - return cached promise
    // - prepare + return cached promise, make api request and resolve later on
    const promises: Promise<ResourceGetEndpoints[E]['response']['body']>[] = resourceRequests.map((request) => {
      const item = this.cache.get(request.resourceURL)
      if (
        item &&
        // Timestamp is undefined until the promise resolved once.
        // After that, it's set to the time when the promise resolved.
        (typeof item.timestamp === 'undefined' || item.timestamp >= tcutoff)
      ) {
        // this returns the same promise if the same id is duplicated in `ids`
        return item.promise
      } else {
        // create the cache item (with promise and executor) once
        const cacheItem = {} as AsyncCacheItem<ResourceGetEndpoints[E]['response']['body']>
        cacheItem.promise = new Promise<ResourceGetEndpoints[E]['response']['body']>((resolve, reject) => {
          cacheItem.promiseResolve = resolve
          cacheItem.promiseReject = reject
        }).then((value) => {
          // start item lifetime only once it has been resolved
          cacheItem.timestamp = Date.now()
          cacheItem.value = value
          return value
        })
        this.cache.set(request.resourceURL, cacheItem)
        // and remember to load once
        apiRequests.set(request.resourceURL, request)
        return cacheItem.promise
      }
    })

    // Make actual API requests. As per
    // - function signature, all requested resources are of same type
    // - dev.005, same-type GET requests can be pooled with comma separated ids
    // However, the request URL is limited in size, hence a long* request can
    // be split into multiple requests which only differ by the id param.
    // *) in terms of passed ids
    if (apiRequests.size > 0) {
      const requests = Array.from(apiRequests.values())
      // use 0th - requests do not differ in structure
      const actualRequest = window.structuredClone(requests[0])
      // options could differ by value if spreading is active and url too long
      let actualRequestOptions = [actualRequest.options]
      // merge ids from requests into manageable chunks if spreading is active
      if (spread) {
        const actualIds = requests.map((request) => request.options!.params![spread!])
        actualRequestOptions = splitArrayIntoChunks(actualIds, MAX_UUIDS_PER_REQUEST).map((ids) => {
          const options = window.structuredClone(actualRequest.options)
          options!.params![spread!] = ids.join(',')
          return options
        })
      }
      const resourcesMixedType = await Promise.all(
        actualRequestOptions.map(
          async (options) =>
            (await this.apiService.get(actualRequest.endpoint, options as BanEmpty<ApiGetOptions<E>>)).body,
        ),
      )
      const resources = resourcesMixedType.flat() as (typeof resourcesMixedType)[0]
      if (resources) {
        // when spreading is active, treat all items in response as individual
        // set of resources
        if (spread) {
          const identProp = meta?.idProperty ?? 'id'
          resources?.forEach((resource) => {
            // if identProp does not exist, do not resolve promise (to cause its
            // rejection later on)
            if (identProp in resource) {
              // the resource URL has to be derived from the request options
              // merged with the responded resource's identifying property
              const resourceOptions = this.cloneOptionsForId(
                actualRequest.options,
                spread,
                resource[identProp as keyof typeof resource],
              )
              const resourceURL = this.getResourceURL(actualRequest.endpoint, resourceOptions)
              const item = this.cache.get(resourceURL)
              //@ts-expect-error undefined
              item?.promiseResolve([resource])
              apiRequests.delete(resourceURL)
            }
          })
        }
        //... otherwise, treat the whole response as one resource
        else {
          const resourceURL = actualRequest.resourceURL
          const item = this.cache.get(resourceURL)
          item?.promiseResolve(resources)
          apiRequests.delete(resourceURL)
        }
      }
      // Resolved apiRequests are removed. Any apiRequest still around means
      // it didn't resolve, indicating something went wrong (e.g. no matching
      // resource was returned).
      // Force rejection of those, otherwise function will never return.
      // Also, invalidate prepared cache object.
      apiRequests.forEach((_request, resourceURL) => {
        const item = this.cache.get(resourceURL)
        item?.promiseReject()
        this.cache.delete(resourceURL)
      })
    }

    //@ts-expect-error undefined (because response body is typed as optional)
    return Promise.all(promises).then((arrays) => arrays.flat(1))
  }

  /**
   * Returns a copy of a `AugmentedApiGetOptions` object with the specified
   * `param` (from `options.params`) replaced by `id`.
   */
  private cloneOptionsForId<E extends keyof ResourceGetEndpoints & {}>(
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
   * Returns a resource URL (endpoint with interpolated parameters and query),
   * uniquely identifying it.
   */
  private getResourceURL<E extends keyof ResourceGetEndpoints & {}, O extends Partial<AugmentedApiGetOptions<E>>>(
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
