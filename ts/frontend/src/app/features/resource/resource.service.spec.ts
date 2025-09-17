import { TestBed } from '@angular/core/testing'

import { SuiteDefinitionRow } from '@common/interfaces'
import { ApiService } from '../api/api.service'
import { ResourceService } from './resource.service'

const dummySuites: SuiteDefinitionRow[] = [
  {
    dir: '/definitions/suites/',
    id: 'a',
    name: 'Suite A',
    description: 'For testing',
    setup: 'DEFAULT',
    benchmark_ids: [],
  },
  {
    dir: '/definitions/suites/',
    id: 'b',
    name: 'Suite B',
    description: 'For testing',
    setup: 'DEFAULT',
    benchmark_ids: [],
  },
]

interface TestCase {
  description: string
  method: 'load' | 'loadGrouped' | 'loadOrdered'
  request: { suite_ids: string | string[] }
  response: SuiteDefinitionRow[]
  apiMock?: {
    request: { suite_ids: string }
    response: SuiteDefinitionRow[]
  }
}

describe('ResourceService', async () => {
  let service: ResourceService
  const apiServiceSpy: jasmine.SpyObj<ApiService> = jasmine.createSpyObj('ApiService', ['get'])

  const testCaseAssertion = async (testCase: TestCase) => {
    // if apiMock is present, use that
    if (testCase.apiMock) {
      apiServiceSpy.get.and.resolveTo({ body: testCase.apiMock.response })
    }
    // otherwise reject calling the api
    else {
      apiServiceSpy.get.and.rejectWith()
    }
    // test if the resource service returns the expected value
    await expectAsync(
      service[testCase.method]('/definitions/suites/:suite_ids', { params: testCase.request }),
    ).toBeResolvedTo(testCase.response)
    // since the api was mocked with a spy, also test if it was invoked correctly
    if (testCase.apiMock) {
      expect(apiServiceSpy.get).toHaveBeenCalledWith('/definitions/suites/:suite_ids', {
        params: testCase.apiMock.request,
      })
      apiServiceSpy.get.calls.reset()
    }
  }

  describe('(general behavior)', async () => {
    // init for each test
    beforeEach(() => {
      TestBed.configureTestingModule({
        providers: [{ provide: ApiService, useValue: apiServiceSpy }],
      })
      service = TestBed.inject(ResourceService)
    })

    it('should be created', () => {
      expect(service).toBeTruthy()
    })

    const testCases: TestCase[] = [
      {
        description: 'should load resource from api',
        method: 'load',
        request: { suite_ids: 'a' },
        response: [dummySuites[0]],
        apiMock: {
          request: { suite_ids: 'a' },
          response: [dummySuites[0]],
        },
      },
      {
        description: 'should load resources (grouped) from api',
        method: 'loadGrouped',
        // response will be requested resources but grouped
        request: { suite_ids: ['a', 'b', 'a'] },
        response: [dummySuites[0], dummySuites[1]],
        // api request should already be consolidated
        apiMock: {
          request: { suite_ids: 'a,b' },
          response: [dummySuites[0], dummySuites[1]],
        },
      },
      {
        description: 'should load resources (ordered) from api',
        method: 'loadOrdered',
        // response will be requested resources in exact order
        request: { suite_ids: ['a', 'b', 'a'] },
        response: [dummySuites[0], dummySuites[1], dummySuites[0]],
        // api request should already be consolidated
        apiMock: {
          request: { suite_ids: 'a,b' },
          response: [dummySuites[0], dummySuites[1]],
        },
      },
    ]

    // NOTE: Although it looks like this is going to cause race condition
    // errors, it will run fine, since Jasmine executes the test callbacks
    // in sequence (random, but still sequentially).
    testCases.forEach((testCase) => {
      it(testCase.description, async () => {
        await testCaseAssertion(testCase)
      })
    })
  })

  describe('(caching)', async () => {
    // init only once to keep cache around (remind that in test cases!)
    beforeAll(() => {
      TestBed.configureTestingModule({
        providers: [{ provide: ApiService, useValue: apiServiceSpy }],
      })
      service = TestBed.inject(ResourceService)
    })

    const testCases: TestCase[] = [
      {
        description: 'should load resource from api',
        method: 'load',
        request: { suite_ids: 'a' },
        response: [dummySuites[0]],
        apiMock: {
          request: { suite_ids: 'a' },
          response: [dummySuites[0]],
        },
      },
      {
        description: 'should then return resource from cache',
        method: 'load',
        request: { suite_ids: 'a' },
        response: [dummySuites[0]],
      },
      {
        description: 'should respect cache in multi-requests',
        method: 'loadGrouped',
        // response will be requested resources but grouped
        request: { suite_ids: ['a', 'b'] },
        response: [dummySuites[0], dummySuites[1]],
        // api request should only request non-cached resources
        apiMock: {
          request: { suite_ids: 'b' },
          response: [dummySuites[1]],
        },
      },
      {
        description: 'should respect cache in single requests after multi-request',
        method: 'loadGrouped',
        request: { suite_ids: 'b' },
        response: [dummySuites[1]],
        // api request should not be made as all resources are already cached
      },
    ]

    // NOTE: Jasmine would run specs in random order, hence do only one test
    // but include all assertions in that one test
    it('should do the caching', async () => {
      for (const testCase of testCases) {
        await testCaseAssertion(testCase)
      }
    })
  })
})
