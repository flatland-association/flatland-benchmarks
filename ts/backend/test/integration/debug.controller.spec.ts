import { DebugController } from '../../src/app/features/controller/debug.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe('Debug Controller Failing controller', () => {
  let controller: ControllerTestAdapter

  test('should time out because of unreachable broker', async () => {
    const testConfig = await getTestConfig()
    testConfig.amqp.port = 2
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(DebugController, testConfig)
    const res = await controller.testGet('/health/', {})
    console.log('= /health =')
    console.log(res.status)
    console.log(res.body)
    expect(res.status).toBe(504)
    expect(res.body).toEqual({error: "Timeout"})
  })

  test('should time out because of unreachable db', async () => {
    const testConfig = await getTestConfig()
    testConfig.postgres.port = 1 // do not use 0 - would fall back to default
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(DebugController, testConfig)
    const res = await controller.testGet('/health/', {})
    console.log('= /health =')
    console.log(res.status)
    console.log(res.body)
    expect(res.status).toBe(504)
    expect(res.body).toEqual({error: "Timeout"})
  })




  test('should return healthy', async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(DebugController, testConfig)
    const res = await controller.testGet('/health/', {})
    console.log('= /health =')
    console.log(res.status)
    console.log(res.body)
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body).toEqual("ready")
  })
})
