import type { Express } from 'express'
import express from 'express'
import { StatusCodes } from 'http-status-codes'
import supertest from 'supertest'
import TestAgent from 'supertest/lib/agent'
import { beforeAll, describe, expect, test } from 'vitest'
import { defaults } from '../config/defaults.mjs'
import { Controller } from './controller.mjs'

const dummyResources = [{ id: '1' }, { id: '2' }]

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
      controller.respond(req, res, '<ok>', '<debug>')
    })
    controller.attachPost('/test-post' as '/mirror', (req, res) => {
      controller.respond(req, res, { data: '<ok>' }, '<debug>')
    })
    controller.attachPatch('/test-patch' as '/mirror/:id', (req, res) => {
      controller.respond(req, res, { data: '<ok>' }, '<debug>')
    })
    controller.attachGet('/test-auth-error' as '/mirror', (req, res) => {
      controller.unauthorizedError(req, res, { text: 'auth error' })
    })
    controller.attachGet('/test-server-error' as '/mirror', (req, res) => {
      controller.respondError(req, res, { text: 'server error' })
    })
    // test fallback error handler with exception
    controller.attachGet('/test-catch' as '/mirror', (_req, _res) => {
      throw 'error'
    })
    // test fallback error handler with undefined handler response
    controller.attachGet('/test-undefined' as '/mirror', (_req, _res) => {
      /* */
    })
    controller.attachGet('/test-presence-check/:suite_ids' as '/definitions/suites/:suite_ids', (req, res) => {
      const ids = req.params.suite_ids.split(',')
      const resources = dummyResources
      //@ts-expect-error suite
      controller.respondAfterPresenceCheck(req, res, resources, ids)
    })
    // test for routes presence
    const routes = getControllerRoutes(controller)
    expect(routes).toContain('/test-get')
    expect(routes).toContain('/test-post')
    expect(routes).toContain('/test-patch')
    expect(routes).toContain('/test-auth-error')
    expect(routes).toContain('/test-server-error')
    expect(routes).toContain('/test-catch')
    expect(routes).toContain('/test-undefined')
    expect(routes).toContain('/test-presence-check/:suite_ids')
    // no more than the the explicitly attached routes should be present
    expect(routes).toHaveLength(8)
  })

  test.each([
    {
      route: '/test-get',
      expects: { status: StatusCodes.OK, response: { body: '<ok>', dbg: '<debug>' } },
    },
    {
      route: '/test-auth-error',
      expects: { status: StatusCodes.UNAUTHORIZED, response: { error: { text: 'auth error' } } },
    },
    {
      route: '/test-no-such-route',
      expects: { status: StatusCodes.NOT_FOUND, response: {} },
    },
    {
      route: '/test-server-error',
      expects: { status: StatusCodes.INTERNAL_SERVER_ERROR, response: { error: { text: 'server error' } } },
    },
    // fallback error handler does not set a response body
    {
      route: '/test-catch',
      expects: { status: StatusCodes.INTERNAL_SERVER_ERROR, response: {} },
    },
    {
      route: '/test-undefined',
      expects: { status: StatusCodes.INTERNAL_SERVER_ERROR, response: {} },
    },
    {
      route: '/test-presence-check/1,2',
      expects: { status: StatusCodes.OK, response: { body: dummyResources } },
    },
    {
      route: '/test-presence-check/1,2,3',
      expects: {
        status: StatusCodes.NOT_FOUND,
        response: { body: dummyResources, error: { text: 'Not Found' }, dbg: ['3'] },
      },
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
