import { TestBed } from '@angular/core/testing'

import { HttpClient } from '@angular/common/http'
import { of } from 'rxjs'
import { Customization, CustomizationService } from './customization.service'

const dummyCustomization: Customization = {
  setup: 'benchmark',
  content: {
    title: 'Testing',
    home: {
      title: 'Tests',
      lead: 'Testing customization',
      benchmarksHeading: 'Testings',
    },
  },
}

describe('CustomizationService', () => {
  let service: CustomizationService
  let httpClientSpy: jasmine.SpyObj<HttpClient>
  let getSpy: jasmine.Spy

  beforeEach(() => {
    httpClientSpy = jasmine.createSpyObj('HttpClient', ['get'])
    TestBed.configureTestingModule({
      providers: [{ provide: HttpClient, useValue: httpClientSpy }],
    })
    service = TestBed.inject(CustomizationService)
    getSpy = httpClientSpy.get.and.returnValue(of(dummyCustomization))
  })

  it('should be created', () => {
    expect(service).toBeTruthy()
  })

  it('should fetch no more than once from backend', async () => {
    let c1: Customization
    // should trigger fetch
    service.getCustomization().then((c) => (c1 = c))
    // should re-use promise
    const c2 = await service.getCustomization()
    // should re-use resolved promise
    const c3 = await service.getCustomization()
    expect(c1!).toEqual(dummyCustomization)
    expect(c2).toEqual(dummyCustomization)
    expect(c3).toEqual(dummyCustomization)
    expect(getSpy).toHaveBeenCalledTimes(1)
  })
})
