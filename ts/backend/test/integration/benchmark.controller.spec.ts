import { ApiGetEndpoints } from '@common/api-endpoints'
import { BenchmarkController } from '../../src/app/features/controller/benchmark.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

const protoBenchmark = [
  {
    dir: '/definitions/benchmarks/',
    id: '20ccc7c1-034c-4880-8946-bffc3fed1359',
    name: 'Benchmark 1',
    description: 'Domain X benchmark',
    field_definition_ids: ['be7bf55a-9d79-4e89-8509-f8d2af9b3fad', 'f6b23ac8-2f12-4e77-8de4-4939b818ca8e'],
    test_definition_ids: ['557d9a00-7e6d-410b-9bca-a017ca7fe3aa'],
  },
] satisfies ApiGetEndpoints['/definitions/benchmarks']['response']['body']

describe('Benchmark controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(BenchmarkController, testConfig)
  })

  test('should return list of benchmarks', async () => {
    const res = await controller.testGet('/definitions/benchmarks', {})
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    // TODO: test interface equality only
    // relies on https://github.com/flatland-association/flatland-benchmarks/issues/181
    // Using toContainEqual with protoBenchmark[0] here, because demo data might
    // contain more than just the prototype benchmark.
    expect(res.body.body).toContainEqual(protoBenchmark[0])
  })

  test('should return benchmark details', async () => {
    const res = await controller.testGet('/definitions/benchmarks/:id', {
      params: { id: '20ccc7c1-034c-4880-8946-bffc3fed1359' },
    })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    // TODO: test interface equality only
    // relies on https://github.com/flatland-association/flatland-benchmarks/issues/181
    expect(res.body.body).toEqual(protoBenchmark)
  })
})
