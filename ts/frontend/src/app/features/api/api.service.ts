import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
import { ApiGetEndpoints, ApiPostEndpoints } from '@common/api-endpoints.mjs'
import { ApiResponse } from '@common/api-response.mjs'
import { ApiGetOptions } from '@common/api-types.mjs'
import { interpolateEndpoint } from '@common/endpoint-utils.mjs'
import type { BanEmpty, Empty, NotKeyOf } from '@common/utility-types.mjs'
import type { RouteParameters } from 'express-serve-static-core'
import { firstValueFrom } from 'rxjs'
import { environment } from '../../../environments/environment'

/*
If there should ever be the possibility to call unregistered endpoints, use the
commented out overloads.
*/

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  constructor(private http: HttpClient) {
    // expose API service for debugging purposes
    //@ts-expect-error any
    window['apiService'] = this
  }

  // typed overload
  /**
   * Send GET request to API.
   * @param endpoint String representation of the enpoint route.
   * @param options Request options.
   * @see {@link ApiGetEndpoints}
   */
  public async get<
    E extends keyof ApiGetEndpoints,
    T extends ApiGetEndpoints[E],
    O extends BanEmpty<ApiGetOptions<E, T['request']['query']>>,
  >(endpoint: E, ...options: Empty extends O ? [options?: undefined] : [O]): Promise<T['response']>
  // un-typed fallback overload
  // (have to use the NotKeyOf approach here, otherwise typed calls with option
  // type mismatch would be interpreted as a call of the un-typed overload and
  // pass linting)
  public async get<E extends string>(endpoint: NotKeyOf<E, ApiGetEndpoints>, options?: unknown): Promise<unknown>
  // Overload for when the response type is known a priori and doesn't need to
  // be inferred from the endpoint.
  // The use of NotKeyOf is necessary, otherwise a type-mismatch in the typed
  // overload will fall through to this one.
  public async get<R, E extends string = string>(
    endpoint: NotKeyOf<E, ApiGetEndpoints>,
    options?: unknown,
  ): Promise<ApiResponse<R>>

  public async get(endpoint: string, options?: { params?: undefined; query?: undefined }) {
    const response = await firstValueFrom(
      this.http.get(this.buildUrl(endpoint, options?.params), { params: options?.query }),
    )
    console.log(response)
    return response
  }

  // typed overload
  /**
   * Send POST request to API.
   * @param endpoint String representation of the enpoint route.
   * @param options Request options.
   * @see {@link ApiGetEndpoints}
   */
  public async post<
    E extends keyof ApiPostEndpoints,
    O extends BanEmpty<{
      params: RouteParameters<E>
      body: ApiPostEndpoints[E]['request']['body']
    }>,
  >(endpoint: E, ...options: Empty extends O ? [options?: undefined] : [O]): Promise<ApiPostEndpoints[E]['response']>
  // un-typed fallback overload
  // public async post<E extends string>(endpoint: NotKeyOf<E, ApiPostEndpoints>, options?: unknown): Promise<unknown>

  public async post(endpoint: string, options?: { params?: undefined; body?: unknown }) {
    const response = await firstValueFrom(this.http.post(this.buildUrl(endpoint, options?.params), options?.body))
    console.log(response)
    return response
  }

  buildUrl(endpoint: string, params?: Record<string, string>) {
    // replace all known :<name> params first
    if (params) {
      endpoint = interpolateEndpoint(endpoint, params)
    }
    // prepend api base (the delimiting '/' is supposed to be in endpoint)
    return `${environment.apiBase}${endpoint}`
  }
}
