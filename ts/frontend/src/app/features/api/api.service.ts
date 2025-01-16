import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
import { ApiGetEndpoints, ApiPostEndpoints } from '@common/api-endpoints.mjs'
import type { BanNull, EmptyToNull } from '@common/utility-types.mjs'
import type { RouteParameters } from 'express-serve-static-core'
import { firstValueFrom } from 'rxjs'
import { environment } from '../../../environments/environment'

/*
If there should ever be the possibility to call unregistered endpoints, use

const symUnregistered = Symbol()
export type UnregisteredEndpoint = string & { [symUnregistered]: number }

and invoke the api method using `"endpoint" as UnregisteredEndpoint`.
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

  public async get<E extends keyof ApiGetEndpoints>(
    endpoint: E,
    options: BanNull<{
      params: EmptyToNull<RouteParameters<E>>
    }>,
  ): Promise<ApiGetEndpoints[E]['response']>
  // public async get(endpoint: UnregisteredEndpoint, options: unknown): Promise<unknown>

  public async get(endpoint: string, options: { params?: undefined }) {
    const response = await firstValueFrom(this.http.get(this.buildUrl(endpoint, options.params)))
    console.log(response)
    return response
  }

  public async post<E extends keyof ApiPostEndpoints>(
    endpoint: E,
    options: BanNull<{
      params: EmptyToNull<RouteParameters<E>>
      body: ApiPostEndpoints[E]['request']['body']
    }>,
  ): Promise<ApiPostEndpoints[E]['response']>
  // public async post(endpoint: UnregisteredEndpoint, options: unknown): Promise<unknown>

  public async post(endpoint: string, options: { params?: undefined; body?: unknown }) {
    const response = await firstValueFrom(this.http.post(this.buildUrl(endpoint, options.params), options.body))
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
