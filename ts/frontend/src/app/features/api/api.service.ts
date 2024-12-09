import { HttpClient } from '@angular/common/http'
import { Injectable } from '@angular/core'
import { firstValueFrom } from 'rxjs'
import { environment } from '../../../environments/environment'

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  constructor(private http: HttpClient) {
    // expose API service for debugging purposes
    //@ts-expect-error any
    window['apiService'] = this
  }

  public async get(endpoint: string) {
    const response = await firstValueFrom(this.http.get(`${environment.apiBase}/${endpoint}`))
    console.log(response)
    return response
  }

  public async post(endpoint: string, body: unknown) {
    const response = await firstValueFrom(this.http.post(`${environment.apiBase}/${endpoint}`, body))
    console.log(response)
    return response
  }
}
