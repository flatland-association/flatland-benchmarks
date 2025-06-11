import { HttpClient } from '@angular/common/http'
import { Injectable, inject } from '@angular/core'
import { ApiGetEndpoints, ApiPatchEndpoints, ApiPostEndpoints } from '@common/api-endpoints'
import { ApiResponse } from '@common/api-response'
import { ApiGetOptions, ApiPatchOptions, ApiPostOptions } from '@common/api-types'
import { interpolateEndpoint } from '@common/endpoint-utils'
import type { BanEmpty, Empty, NotKeyOf } from '@common/utility-types'
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
  private http = inject(HttpClient)

  constructor() {
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
  public async get<E extends keyof ApiGetEndpoints, O extends BanEmpty<ApiGetOptions<E>>>(
    endpoint: E,
    ...options: Empty extends O ? [options?: undefined] : [O]
  ): Promise<ApiGetEndpoints[E]['response']>
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
    return response
  }

  // typed overload
  /**
   * Send POST request to API.
   * @param endpoint String representation of the enpoint route.
   * @param options Request options.
   * @see {@link ApiGetEndpoints}
   */
  public async post<E extends keyof ApiPostEndpoints, O extends BanEmpty<ApiPostOptions<E>>>(
    endpoint: E,
    ...options: Empty extends O ? [options?: undefined] : [O]
  ): Promise<ApiPostEndpoints[E]['response']>
  // un-typed fallback overload
  // public async post<E extends string>(endpoint: NotKeyOf<E, ApiPostEndpoints>, options?: unknown): Promise<unknown>

  public async post(endpoint: string, options?: { params?: undefined; body?: unknown }) {
    const response = await firstValueFrom(this.http.post(this.buildUrl(endpoint, options?.params), options?.body))
    return response
  }

  // typed overload
  /**
   * Send PATCH request to API.
   * @param endpoint String representation of the enpoint route.
   * @param options Request options.
   * @see {@link ApiGetEndpoints}
   */
  public async patch<E extends keyof ApiPatchEndpoints, O extends BanEmpty<ApiPatchOptions<E>>>(
    endpoint: E,
    ...options: Empty extends O ? [options?: undefined] : [O]
  ): Promise<ApiPatchEndpoints[E]['response']>
  // un-typed fallback overload
  // public async post<E extends string>(endpoint: NotKeyOf<E, ApiPatchEndpoints>, options?: unknown): Promise<unknown>

  public async patch(endpoint: string, options?: { params?: undefined; body?: unknown }) {
    const response = await firstValueFrom(this.http.patch(this.buildUrl(endpoint, options?.params), options?.body))
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
