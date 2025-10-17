import { dbgRequestObject } from '../../src/app/features/controller/controller.mjs'
import { DebugController } from '../../src/app/features/controller/debug.controller.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment, testUserJwt } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

Logger.setOptions({ '--log-level': 'OFF' })

describe('Debug controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(DebugController, testConfig)
  })

  test('should mirror request in dbg prop in GET /mirror', async () => {
    const res = await controller.testGet('/mirror', {})
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body?.dbg).toBeTruthy()
  })

  test('should mirror request in dbg prop in GET /mirror', async () => {
    const res = await controller.testGet('/mirror/:id', { params: { id: '1' } })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body?.dbg).toBeTruthy()
  })

  test('should mirror request in dbg prop in POST /mirror', async () => {
    const res = await controller.testPost('/mirror', { body: { data: [1] } })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body?.dbg).toBeTruthy()
  })

  test('should mirror request in dbg prop in PATCH /mirror/:id', async () => {
    const res = await controller.testPatch('/mirror/:id', {
      params: { id: '1' },
      body: { data: [1] },
    })
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body?.dbg).toBeTruthy()
    // check conformity of dbg object at least once
    const dbg = res.body?.dbg as ReturnType<typeof dbgRequestObject>
    expect(dbg.url).toBe('/mirror/1')
    expect(dbg.query).toEqual({})
    expect(dbg.path).toBe('/mirror/1')
    expect(dbg.params).toEqual({ id: '1' })
    expect(dbg.body).toEqual({ data: [1] })
  })

  test('should give details for logged in users on /whoami', async () => {
    const res = await controller.testGet('/whoami', {}, testUserJwt)
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    console.log(res.body?.body)
    expect(res.body?.body).toEqual({
      id: testUserJwt.sub,
      email: undefined,
      name: undefined,
    })
  })

  test('should deny details for logged out users on /whoami', async () => {
    const res = await controller.testGet('/whoami', {})
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body?.body).toEqual(null)
  })
})
