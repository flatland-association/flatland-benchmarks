import { inject, Injectable } from '@angular/core'
import { BenchmarkDefinitionRow, BenchmarkGroupDefinitionRow, FieldDefinitionRow } from '@common/interfaces'
import { ApiService } from '../api/api.service'

interface AsyncCacheItem<T> {
  value?: T
  promise: Promise<T>
  promiseResolve: (value: T) => void
  promiseReject: (reason?: unknown) => void
}

// TODO: Infer from GET endpoints?
// see: https://github.com/flatland-association/flatland-benchmarks/issues/396
export interface ResourceTypes {
  '/definitions/benchmark-groups/': BenchmarkGroupDefinitionRow
  '/definitions/benchmarks/': BenchmarkDefinitionRow
  '/definitions/fields/': FieldDefinitionRow
}

// TODO: unit test

@Injectable({
  providedIn: 'root',
})
export class ResourceService {
  private apiService = inject(ApiService)

  private cache = new Map<string, AsyncCacheItem<unknown>>()

  /**
   * Load resource from cache or backend, if not cached yet.
   * @param dir
   * @param id
   * @returns
   */
  async load<T extends keyof ResourceTypes>(dir: T, id: string): Promise<ResourceTypes[T]> {
    return this.loadMultiOrdered(dir, [id]).then(([r]) => r)
  }

  /**
   * Load multiple resources from cache or backend, if not cached yet.
   * Returned resources are not in order of passed ids.
   */
  async loadMultiGrouped<T extends keyof ResourceTypes>(dir: T, ids: string[]): Promise<ResourceTypes[T][]> {
    return this.loadMultiOrdered(dir, [...new Set(ids)])
  }

  /**
   * Load multiple resources from cache or backend, if not cached yet.
   * Returned resources are in order of passed ids.
   * @param dir
   * @param ids
   * @returns
   */
  async loadMultiOrdered<T extends keyof ResourceTypes>(dir: T, ids: string[]): Promise<ResourceTypes[T][]> {
    const toLoad = new Set<string>()
    // go through all given ids (in order) and either
    // - return cached promise
    // - prepare + return cached promise, then load and resolve later on
    const promises = ids.map((id) => {
      const item = this.cache.get(`${dir}${id}`)
      if (item) {
        // this returns the same promise if the same id is duplicated in `ids`
        return item.promise
      } else {
        // create the cache item (with promise and executor) once
        const cacheItem = {} as AsyncCacheItem<ResourceTypes[T]>
        cacheItem.promise = new Promise<ResourceTypes[T]>((resolve, reject) => {
          cacheItem.promiseResolve = resolve
          cacheItem.promiseReject = reject
        }).then((value) => {
          cacheItem.value = value
          return value
        })
        //@ts-expect-error subtype
        this.cache.set(`${dir}${id}`, cacheItem)
        // and remember to load once
        toLoad.add(id)
        return cacheItem.promise
      }
    })
    if (toLoad.size) {
      // trust the resource GET endpoint follows the pattern /dir/ids
      const resources = (
        await this.apiService.get<ResourceTypes[T][]>(`${dir}:ids`, { params: { ids: [...toLoad].join(',') } })
      ).body
      // go through all loaded resources and resolve the cached promise
      resources?.forEach((resource) => {
        const item = this.cache.get(`${dir}${resource.id}`)
        item?.promiseResolve(resource)
      })
    }
    //@ts-expect-error type
    return Promise.all(promises)
  }

  /**
   * Tries to retrieve the resource from cache.
   */
  getSync<T extends keyof ResourceTypes>(dir: T, id: string): ResourceTypes[T] | undefined {
    //@ts-expect-error type
    return this.cache.get(`${dir}${id}`)?.value
  }
}
