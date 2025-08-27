import { InfoController } from '../../src/app/features/controller/info.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe('Info Controller Failing controller', () => {
  let controller: ControllerTestAdapter

  test('should return version', async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(InfoController, testConfig)
    const res = await controller.testGet('/info', {})
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body).toEqual({
      version: '999',
    })
  })
})
