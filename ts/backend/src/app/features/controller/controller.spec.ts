import type { Express } from 'express'
import express from 'express'
import supertest from 'supertest'
import TestAgent from 'supertest/lib/agent'
import { beforeAll, describe, expect, test } from 'vitest'
import { defaults } from '../config/defaults.mjs'
import { Controller } from './controller.mjs'

describe.sequential('Controller', () => {
  let app: Express
  let request: TestAgent
  let controller: Controller

  beforeAll(() => {
    app = express()
    request = supertest(app)
  })

  test('should be instantiated (with default configuration)', () => {
    controller = new Controller(defaults)
    expect(controller.router).toBeTruthy()
    app.use(controller.router)
  })

  // All `attach<Verb>` methods are aliases for the private `attach`. Hence let
  // us assume that by testing one (i.e. `attachGet`), all of them are tested
  // sufficiently.
  test('should be able to attach handlers', () => {
    // can't attach to undefined endpoints, but can trick TS into see them as defined
    controller.attachGet('/test-get' as '/mirror', (req, res) => {
      controller.respond(res, '<ok>', '<debug>')
    })
    controller.attachPost('/test-post' as '/mirror', (req, res) => {
      controller.respond(res, { data: '<ok>' }, '<debug>')
    })
    controller.attachPatch('/test-patch' as '/mirror/:id', (req, res) => {
      controller.respond(res, { data: '<ok>' }, '<debug>')
    })
    controller.attachGet('/test-request-error' as '/mirror', (req, res) => {
      controller.requestError(res, { text: 'request error' })
    })
    controller.attachGet('/test-auth-error' as '/mirror', (req, res) => {
      controller.unauthorizedError(res, { text: 'auth error' })
    })
    controller.attachGet('/test-server-error' as '/mirror', (req, res) => {
      controller.serverError(res, { text: 'server error' })
    })
    // test fallback error handler with exception
    controller.attachGet('/test-catch' as '/mirror', (_req, _res) => {
      throw 'error'
    })
    // test fallback error handler with undefined handler response
    controller.attachGet('/test-undefined' as '/mirror', (_req, _res) => {
      /* */
    })
    // test for routes presence
    const routes = getControllerRoutes(controller)
    expect(routes).toContain('/test-get')
    expect(routes).toContain('/test-post')
    expect(routes).toContain('/test-patch')
    expect(routes).toContain('/test-request-error')
    expect(routes).toContain('/test-auth-error')
    expect(routes).toContain('/test-server-error')
    expect(routes).toContain('/test-catch')
    expect(routes).toContain('/test-undefined')
    // no more than the the explicitly attached routes should be present
    expect(routes).toHaveLength(8)
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
      route: '/test-no-such-route',
      expects: { status: 404, response: {} },
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
