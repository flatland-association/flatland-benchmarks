import { TestController } from '../../src/app/features/controller/test.controller.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
} from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Test controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(TestController, testConfig)
  })

  test('should return test by id', async () => {
    const res = await controller.testGet('/definitions/tests/:test_ids', {
      params: { test_ids: 'aeabd5b9-4e86-4c7a-859f-a32ff1be5516' },
    })
    assertApiResponse(res)
  })
})
