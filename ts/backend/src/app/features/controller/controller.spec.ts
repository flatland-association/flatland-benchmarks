import type { Express } from 'express'
import express from 'express'
import supertest from 'supertest'
import TestAgent from 'supertest/lib/agent'
import { beforeAll, describe, expect, test } from 'vitest'
import { configuration } from '../config/config.mjs'
import { defaults } from '../config/defaults.mjs'
import { Controller } from './controller.mjs'

// Custom test controller to test Controller's basic functionality.
// All `attach<Verb>` methods are aliases for the private `attach`. Hence let
// us assume that by testing one (i.e. `attachGet`), all of them are tested
// sufficiently.
class TestController extends Controller {
  constructor(config: configuration) {
    super(config)

    // can't attach to undefined endpoints, but can trick TS into see them as defined
    this.attachGet('/test-get' as '/mirror', (req, res) => {
      this.respond(res, '<ok>', '<debug>')
    })
    this.attachGet('/test-request-error' as '/mirror', (req, res) => {
      this.requestError(res, { text: 'request error' })
    })
    this.attachGet('/test-auth-error' as '/mirror', (req, res) => {
      this.unauthorizedError(res, { text: 'auth error' })
    })
    this.attachGet('/test-server-error' as '/mirror', (req, res) => {
      this.serverError(res, { text: 'server error' })
    })
    // test fallback error handler with exception
    this.attachGet('/test-catch' as '/mirror', (_req, _res) => {
      throw 'error'
    })
    // test fallback error handler with undefined handler response
    this.attachGet('/test-undefined' as '/mirror', (_req, _res) => {
      /* */
    })
  }
}

describe.sequential('Controller', () => {
  let app: Express
  let request: TestAgent
  let testController: Controller

  beforeAll(() => {
    app = express()
    request = supertest(app)
  })

  test('should be instantiated (with default configuration)', () => {
    testController = new TestController(defaults)
    expect(testController.router).toBeTruthy()
    app.use(testController.router)
  })

  test('should have handlers attached', () => {
    const routes = getControllerRoutes(testController)
    expect(routes).toContain('/test-get')
    expect(routes).toContain('/test-request-error')
    expect(routes).toContain('/test-auth-error')
    expect(routes).toContain('/test-server-error')
    expect(routes).toContain('/test-catch')
    expect(routes).toContain('/test-undefined')
    expect(routes).not.toContain('/mirror')
  })

  test.each([
    {
      route: '/test-get',
      expects: { status: 200, response: { body: '<ok>', dbg: '<debug>' } },
    },
    {
      route: '/test-request-error',
      expects: { status: 400, response: { error: { text: 'request error' } } },
    },
    {
      route: '/test-auth-error',
      expects: { status: 401, response: { error: { text: 'auth error' } } },
    },
    {
      route: '/test-server-error',
      expects: { status: 500, response: { error: { text: 'server error' } } },
    },
    // fallback error handler does not set a response body
    {
      route: '/test-catch',
      expects: { status: 500, response: {} },
    },
    {
      route: '/test-undefined',
      expects: { status: 500, response: {} },
    },
  ])('should answer $route with $expects', async (testCase) => {
    const res = await request.get(testCase.route)
    expect(res.statusCode).toBe(testCase.expects.status)
    if (typeof testCase.expects.response !== 'undefined') {
      expect(res.body).toEqual(testCase.expects.response)
    }
  })
})

function getControllerRoutes(controller: Controller): string[] {
  return controller.router.stack.filter((r) => r.route).map((r) => r.route!.path)
}
