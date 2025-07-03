import { TestController } from '../../src/app/features/controller/test.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Test controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(TestController, testConfig)
  })

  test('should return test by id', async () => {
    const res = await controller.testGet('/definitions/tests/:test_ids', { params: { ids: '1' } })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
  })
})
