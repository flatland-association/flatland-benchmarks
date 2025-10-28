import { TestBed } from '@angular/core/testing'

import { HttpClient } from '@angular/common/http'
import { of } from 'rxjs'
import { environment } from '../../../environments/environment'
import { ApiService } from './api.service'

describe('ApiService', () => {
  let service: ApiService
  let httpClientSpy: jasmine.SpyObj<HttpClient>
  let getMock: jasmine.Spy
  let postMock: jasmine.Spy
  let patchMock: jasmine.Spy

  beforeEach(() => {
    httpClientSpy = jasmine.createSpyObj('HttpClient', ['get', 'post', 'patch'])
    TestBed.configureTestingModule({
      providers: [{ provide: HttpClient, useValue: httpClientSpy }],
    })
    service = TestBed.inject(ApiService)
  })

  afterEach(() => {
    getMock?.calls.reset()
    postMock?.calls.reset()
    patchMock?.calls.reset()
  })

  it('should be created', () => {
    expect(service).toBeTruthy()
  })

  it('should build urls based on the environment', () => {
    expect(service.buildUrl('/mirror/:id', { id: '1' })).toBe(`${environment.apiBase}/mirror/1`)
  })

  it('should interpolate endpoint urls using buildUrl', async () => {
    getMock = httpClientSpy.get.and.returnValue(of({ body: 'tested get' }))
    postMock = httpClientSpy.post.and.returnValue(of({ body: { data: 'tested post' } }))
    patchMock = httpClientSpy.patch.and.returnValue(of({ body: { data: 'tested patch' } }))
    // spy on buildUrl to count how often it has been called
    spyOn(service, 'buildUrl')
    expect((await service.get('/mirror')).body).toEqual('tested get')
    expect((await service.post('/mirror', { body: { data: {} } })).body).toEqual({ data: 'tested post' })
    expect((await service.patch('/mirror/:id', { params: { id: '1' }, body: { data: {} } })).body).toEqual({
      data: 'tested patch',
    })
    // must match number of service.<method> calls above
    expect(service.buildUrl).toHaveBeenCalledTimes(3)
  })

  it('should return a promise even in case of errors', async () => {
    // spy on buildUrl to build a 100% unreachable url
    spyOn(service, 'buildUrl').and.returnValue('http://127.0.0.1:0')
    await expectAsync(service.get('/mirror')).toBeRejected()
  })
})
