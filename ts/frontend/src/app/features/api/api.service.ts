import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
import { ApiGetEndpoints, ApiPostEndpoints } from '@common/api-endpoints.mjs'
import type { BanEmpty, Empty } from '@common/utility-types.mjs'
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
    O extends BanEmpty<{
      params: RouteParameters<E>
    }>,
  >(endpoint: E, ...options: Empty extends O ? [options?: undefined] : [O]): Promise<ApiGetEndpoints[E]['response']>
  // un-typed fallback overload
  // public async get<E extends string>(endpoint: NotKeyOf<E, ApiGetEndpoints>, options?: unknown): Promise<unknown>

  public async get(endpoint: string, options?: { params?: undefined }) {
    const response = await firstValueFrom(this.http.get(this.buildUrl(endpoint, options?.params)))
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
      Object.entries(params).forEach(([key, value]) => {
        // replace ':' + key + boundary with interpolated value
        endpoint = endpoint.replace(new RegExp(`:${key}\\b`), `${value}`)
      })
    }
    // prepend api base (the delimiting '/' is supposed to be in endpoint)
    return `${environment.apiBase}${endpoint}`
  }
}
