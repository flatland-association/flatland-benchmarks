import { SuiteController } from '../../src/app/features/controller/suite.controller.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
} from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

Logger.setOptions({ '--log-level': 'OFF' })

describe.sequential('Suite controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(SuiteController, testConfig)
  })

  // data set in
  // - ts/backend/src/migration/data/V5.1__validation_campaign.sql
  test('should return suites', async () => {
    const res = await controller.testGet('/definitions/suites', {})
    assertApiResponse(res)
    const suiteIds = res.body.body.map((s) => s.id)
    expect(suiteIds).toContain('0ca46887-897a-463f-bf83-c6cd6269a976')
  })

  test('should return suite by id', async () => {
    const res = await controller.testGet('/definitions/suites/:suite_ids', {
      params: { suite_ids: '0ca46887-897a-463f-bf83-c6cd6269a976' },
    })
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
  })
})
