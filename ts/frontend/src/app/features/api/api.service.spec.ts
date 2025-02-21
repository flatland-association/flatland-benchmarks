import { TestBed } from '@angular/core/testing'

import { provideHttpClient } from '@angular/common/http'
import { environment } from '../../../environments/environment'
import { ApiService } from './api.service'

describe('ApiService', () => {
  let service: ApiService

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient()],
    })
    service = TestBed.inject(ApiService)
  })

  it('should be created', () => {
    expect(service).toBeTruthy()
  })

  it('should build urls based on the environment', () => {
    expect(service.buildUrl('/mirror')).toBe(`${environment.apiBase}/mirror`)
  })

  it('should define endpoint urls using buildUrl', () => {
    // spy on buildUrl to count how often it has been called
    spyOn(service, 'buildUrl')
    service.get('/mirror').catch(() => undefined)
    service.post('/mirror', { body: { data: null } }).catch(() => undefined)
    // must match number of service.<method> calls above
    expect(service.buildUrl).toHaveBeenCalledTimes(2)
  })

  it('should return a promise even in case of errors', async () => {
    // spy on buildUrl to build a 100% unreachable url
    spyOn(service, 'buildUrl').and.returnValue('http://127.0.0.1:0')
    await expectAsync(service.get('/mirror')).toBeRejected()
  })
})
