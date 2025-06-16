import { HealthController } from '../../src/app/features/controller/health.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe('Health Controller Failing controller', () => {
  let controller: ControllerTestAdapter

  test('should because of unreachable broker', async () => {
    const testConfig = await getTestConfig()
    testConfig.amqp.host = "nix.amqp.com"
    testConfig.amqp.port = 2
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(HealthController, testConfig)
    const res = await controller.testGet('/health/live/', {})
    console.log('= /health/live =')
    console.log(res.status)
    console.log(res.body)
    expect(res.status).toBe(503)
  })

  test('should fail because unreachable db', async () => {
    const testConfig = await getTestConfig()
    testConfig.postgres.host = "nix.postgres.com"
    testConfig.postgres.port = 1 // do not use 0 - would fall back to default
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(HealthController, testConfig)
    const res = await controller.testGet('/health/live/', {})
    console.log('= /health/live =')
    console.log(res.status)
    console.log(res.body)
    expect(res.status).toBe(503)
  })

  test('should return healthy', async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(HealthController, testConfig)
    const res = await controller.testGet('/health/live/', {})
    console.log('= /health/live =')
    console.log(res.status)
    console.log(res.body)
    expect(res.status).toBe(200)
    expect(res.body).toEqual({
     "status": "UP",
     "checks": [
       {
         "name": "SqlService",
         "status": "UP",
       },
       {
         "name": "CeleryService",
         "status": "UP"
       }
     ]
   })
  })
})
