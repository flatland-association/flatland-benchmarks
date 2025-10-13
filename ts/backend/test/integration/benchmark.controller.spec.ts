import { ApiGetEndpoints } from '@common/api-endpoints'
import { BenchmarkController } from '../../src/app/features/controller/benchmark.controller.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
} from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

Logger.setOptions({ '--log-level': 'OFF' })

const protoBenchmark = [
  {
    dir: '/definitions/benchmarks/',
    id: '20ccc7c1-034c-4880-8946-bffc3fed1359',
    name: 'Benchmark 1',
    description: 'Domain X benchmark',
    field_ids: ['be7bf55a-9d79-4e89-8509-f8d2af9b3fad', 'f6b23ac8-2f12-4e77-8de4-4939b818ca8e'],
    campaign_field_ids: [],
    test_ids: ['557d9a00-7e6d-410b-9bca-a017ca7fe3aa'],
    suite_id: null,
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
    assertApiResponse(res)
    // Using toContainEqual with protoBenchmark[0] here, because demo data might
    // contain more than just the prototype benchmark.
    expect(res.body.body).toContainEqual(protoBenchmark[0])
  })

  test('should return benchmark details', async () => {
    const res = await controller.testGet('/definitions/benchmarks/:benchmark_ids', {
      params: { benchmark_ids: '20ccc7c1-034c-4880-8946-bffc3fed1359' },
    })
    assertApiResponse(res)
    expect(res.body.body).toEqual(protoBenchmark)
  })
})
