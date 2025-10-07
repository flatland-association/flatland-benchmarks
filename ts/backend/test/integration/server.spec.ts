import supertest from 'supertest'
import TestAgent from 'supertest/lib/agent'
import { defaults } from '../../src/app/features/config/defaults.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import { Server } from '../../src/app/features/server/server.mjs'
import serverTest from '../public/test.json'

Logger.setOptions({ '--log-level': 'OFF' })

describe('Server', () => {
  let server: Server
  let request: TestAgent

  beforeAll(() => {
    // NOTE: Vitest runs tests in ts/backend but the server expects to find
    // static files in ../public - to solve this, change the current working
    // directory for this spec* to ts/backend/test/integration, so ../public
    // points to ts/backend/test/public where the test .json can be found.
    // *) Vitest runs specs in isolated processes, so this chdir only affects
    // this spec.
    process.chdir('test/integration')
    server = new Server(defaults)
    request = supertest(server.app)
  })

  it('is instantiated', () => {
    expect(server).toBeTruthy()
  })

  it('serves static files', async () => {
    const response = await request.get('/public/test.json')
    expect(response.statusCode).toBe(200)
    expect(response.body).toEqual(serverTest)
  })

  it('serves api-docs', async () => {
    const response = await request.get('/api-docs')
    // the api-docs root will redirect
    expect(response.statusCode).toBe(301)
  })

  it('uses controllers', async () => {
    const response = await request.get('/mirror')
    expect(response.statusCode).toBe(200)
  })

  it('uses error handling middleware in case of controller error', async () => {
    const response = await request.post('/mirror')
    expect(response.statusCode).toBe(500)
    expect(response.body?.error?.text).toBeTypeOf('string')
  })
})
