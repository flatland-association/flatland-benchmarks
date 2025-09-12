import { FieldController } from '../../src/app/features/controller/field.controller.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
} from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Field controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(FieldController, testConfig)
  })

  test('should return scenario by id', async () => {
    const res = await controller.testGet('/definitions/fields/:field_ids', {
      params: { field_ids: '9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b' },
    })
    assertApiResponse(res)
    expect(res.body.body.at(0)).toBeTruthy()
  })
})
