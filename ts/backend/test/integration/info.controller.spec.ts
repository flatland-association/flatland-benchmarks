import { InfoController } from '../../src/app/features/controller/info.controller.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
} from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

Logger.setOptions({ '--log-level': 'OFF' })

describe('Info Controller Failing controller', () => {
  let controller: ControllerTestAdapter

  test('should return version', async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(InfoController, testConfig)
    const res = await controller.testGet('/info', {})
    assertApiResponse(res)
    expect(res.body.body).toEqual({
      version: '999',
    })
  })
})
