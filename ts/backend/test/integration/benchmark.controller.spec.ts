import { ApiGetEndpoints } from '@common/api-endpoints'
import { BenchmarkController } from '../../src/app/features/controller/benchmark.controller.mjs'
import { SqlService } from '../../src/app/features/services/sql-service.mjs'
import { ControllerTestAdapter } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe('Benchmark controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    SqlService.create(testConfig)
    controller = new ControllerTestAdapter(BenchmarkController, testConfig)
  })

  test('should return list of benchmarks', async () => {
    const res = await controller.testGet('/benchmarks', {})
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    // TODO: test interface equality only
    // relies on https://github.com/flatland-association/flatland-benchmarks/issues/181
    const proto = [
      {
        dir: '/benchmarks/',
        id: 1,
        name: 'Flatland 3',
        description: 'This is the first permanent Flatland benchmark.',
      },
    ] satisfies ApiGetEndpoints['/benchmarks']['response']['body']
    expect(res.body.body).toEqual(proto)
  })

  test('should return benchmark details', async () => {
    const res = await controller.testGet('/benchmarks/:id', { params: { id: '1' } })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    // TODO: test interface equality only
    // relies on https://github.com/flatland-association/flatland-benchmarks/issues/181
    const proto = [
      {
        dir: '/benchmarks/',
        id: 1,
        name: 'Flatland 3',
        description: 'This is the first permanent Flatland benchmark.',
        docker_image: 'ghcr.io/flatland-association/fab-flatland-evaluator:latest',
        tests: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
      },
    ] satisfies ApiGetEndpoints['/benchmarks/:id']['response']['body']
    expect(res.body.body).toEqual(proto)
  })
})
