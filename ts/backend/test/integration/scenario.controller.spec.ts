import { ScenarioController } from '../../src/app/features/controller/scenario.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Scenario controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(ScenarioController, testConfig)
  })

  test('should return scenario by id', async () => {
    const res = await controller.testGet('/definitions/scenarios/:scenario_ids', {
      params: { scenario_ids: '8fba6834-cd86-4bca-b3b5-f14d6c54d92f' },
    })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body?.at(0)).toBeTruthy()
  })
})
