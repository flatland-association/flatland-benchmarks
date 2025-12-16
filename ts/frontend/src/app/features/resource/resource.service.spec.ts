import { TestBed } from '@angular/core/testing'

import { MAX_UUIDS_PER_REQUEST } from '@common/utility-functions'
import { ApiService } from '../api/api.service'
import { ResourceService } from './resource.service'

interface DummySuiteRow {
  id: string
}

const dummySuites: DummySuiteRow[] = Array.from({ length: MAX_UUIDS_PER_REQUEST + 1 }, (_, i) => {
  return {
    id: `${i}`,
  }
})

interface TestCase {
  description: string
  method: 'load' | 'loadGrouped' | 'loadOrdered'
  request: { suite_ids: string | string[] }
  response: DummySuiteRow[]
  apiMocks?: {
    request: { suite_ids: string }
    response: DummySuiteRow[]
  }[]
}

describe('ResourceService', async () => {
  let service: ResourceService
  const apiServiceSpy: jasmine.SpyObj<ApiService> = jasmine.createSpyObj('ApiService', ['get'])

  const testCaseAssertion = async (testCase: TestCase) => {
    // if apiMock is present, use that
    if (testCase.apiMocks) {
      // apiServiceSpy.get.and.resolveTo({ body: testCase.apiMock.response })
      let callNr = 0
      // resolve with mocked responses in order
      apiServiceSpy.get.and.callFake(() => {
        const ret = Promise.resolve({ body: testCase.apiMocks![callNr].response })
        callNr += 1
        return ret
      })
    }
    // otherwise reject calling the api
    else {
      apiServiceSpy.get.and.rejectWith()
    }
    // test if the resource service returns the expected value
    await expectAsync(
      service[testCase.method]('/definitions/suites/:suite_ids', { params: testCase.request }) as Promise<
        DummySuiteRow[]
      >,
    ).toBeResolvedTo(testCase.response)
    // since the api was mocked with a spy, also test if it was invoked correctly
    if (testCase.apiMocks) {
      testCase.apiMocks.map((mock) => {
        expect(apiServiceSpy.get).toHaveBeenCalledWith('/definitions/suites/:suite_ids', {
          params: mock.request,
        })
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
        request: { suite_ids: '0' },
        response: [dummySuites[0]],
        apiMocks: [
          {
            request: { suite_ids: '0' },
            response: [dummySuites[0]],
          },
        ],
      },
      {
        description: 'should load resources (grouped) from api',
        method: 'loadGrouped',
        // response will be requested resources but grouped
        request: { suite_ids: ['0', '1', '0'] },
        response: [dummySuites[0], dummySuites[1]],
        // api request should already be consolidated
        apiMocks: [
          {
            request: { suite_ids: '0,1' },
            response: [dummySuites[0], dummySuites[1]],
          },
        ],
      },
      {
        description: 'should load resources (ordered) from api',
        method: 'loadOrdered',
        // response will be requested resources in exact order
        request: { suite_ids: ['0', '1', '0'] },
        response: [dummySuites[0], dummySuites[1], dummySuites[0]],
        // api request should already be consolidated
        apiMocks: [
          {
            request: { suite_ids: '0,1' },
            response: [dummySuites[0], dummySuites[1]],
          },
        ],
      },
      {
        description: 'should split long requests into multiple chunks',
        method: 'loadOrdered',
        // response will be all requested resources in exact order
        request: { suite_ids: dummySuites.map((d) => d.id) },
        response: [...dummySuites],
        // api request should be split into chunks
        apiMocks: [
          {
            request: {
              suite_ids: dummySuites
                .slice(0, MAX_UUIDS_PER_REQUEST)
                .map((d) => d.id)
                .join(','),
            },
            response: dummySuites.slice(0, MAX_UUIDS_PER_REQUEST),
          },
          {
            request: {
              suite_ids: dummySuites
                .slice(MAX_UUIDS_PER_REQUEST)
                .map((d) => d.id)
                .join(','),
            },
            response: dummySuites.slice(MAX_UUIDS_PER_REQUEST),
          },
        ],
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
        request: { suite_ids: '0' },
        response: [dummySuites[0]],
        apiMocks: [
          {
            request: { suite_ids: '0' },
            response: [dummySuites[0]],
          },
        ],
      },
      {
        description: 'should then return resource from cache',
        method: 'load',
        request: { suite_ids: '0' },
        response: [dummySuites[0]],
      },
      {
        description: 'should respect cache in multi-requests',
        method: 'loadGrouped',
        // response will be requested resources but grouped
        request: { suite_ids: ['0', '1'] },
        response: [dummySuites[0], dummySuites[1]],
        // api request should only request non-cached resources
        apiMocks: [
          {
            request: { suite_ids: '1' },
            response: [dummySuites[1]],
          },
        ],
      },
      {
        description: 'should respect cache in single requests after multi-request',
        method: 'loadGrouped',
        request: { suite_ids: '1' },
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
