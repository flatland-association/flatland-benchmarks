import { TestController } from '../../src/app/features/controller/test.controller.mjs'
import { AmqpService } from '../../src/app/features/services/amqp-service.mjs'
import { AuthService } from '../../src/app/features/services/auth-service.mjs'
import { SqlService } from '../../src/app/features/services/sql-service.mjs'
import { ControllerTestAdapter } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Test controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    AmqpService.create(testConfig)
    AuthService.create(testConfig)
    SqlService.create(testConfig)
    controller = new ControllerTestAdapter(TestController, testConfig)
  })

  test('should return test by id', async () => {
    const res = await controller.testGet('/tests/:id', { params: { id: '1' } })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
  })
})
