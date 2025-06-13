import { ApiGetEndpoints, ApiPostEndpoints } from '@common/api-endpoints'
import { ApiGetOptions, ApiPostOptions } from '@common/api-types'
import { interpolateEndpoint } from '@common/endpoint-utils'
import { BanEmpty } from '@common/utility-types'
import type { Express } from 'express'
import express from 'express'
import { JwtPayload } from 'jsonwebtoken'
import supertest from 'supertest'
import TestAgent from 'supertest/lib/agent'
import { expect, vi } from 'vitest'
import { configuration } from '../src/app/features/config/config.mjs'
import { Controller } from '../src/app/features/controller/controller.mjs'
import { CeleryService } from '../src/app/features/services/celery-client-service.mjs'
import { AuthService } from '../src/app/features/services/auth-service.mjs'
import { SqlService } from '../src/app/features/services/sql-service.mjs'

/*
Controllers are tested using the "supertest" testing framework, where requests
are mocked directly into the express server applet instead of being sent via
http/https. For this to work, every controller under test has to be injected
into a newly booted and configured express app.

This file, especially the `ControllerTestAdapter` class, unifies this setup
step.

Additionally, it mocks `AuthService` to always resolve with a specified
authorization state. That way, controllers can be tested under different and
well-defined users.
*/

// common test case users (as maximally reduced jwt payload)
export const testUserJwt: JwtPayload = {
  sub: '00000000-0000-0000-0000-000000000001',
  preferred_username: 'Test User',
}

/*
Globally extend vitest for custom API tests.
*/

interface CustomMatchers<R = unknown> {
  toBeApiResponse: () => R
}

declare module 'vitest' {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any, @typescript-eslint/no-empty-object-type
  interface Assertion<T = any> extends CustomMatchers<T> {}
}

expect.extend({
  toBeApiResponse: (received, _expected) => {
    let pass = false
    // ApiResponse must have either .body or .error.text
    if (typeof received?.body !== 'undefined' || typeof received?.error?.text !== 'undefined') {
      pass = true
    }
    return {
      message: () => `expected ${JSON.stringify(received)} to be an ApiResponse`,
      pass,
    }
  },
})

/**
 * Adapter class putting `Controller` under test.
 */
export class ControllerTestAdapter {
  app: Express
  request: TestAgent
  controller: Controller

  constructor(ctor: typeof Controller, config: configuration) {
    this.controller = new ctor(config)
    this.app = express()
    this.app.use(express.json())
    this.request = supertest(this.app)
    this.app.use(this.controller.router)
  }

  // Wraps callback in a mocked authorized state
  private async withMockedAuth<T>(cb: () => Promise<T>, jwt: JwtPayload | null = null) {
    // mock AuthService to always pass authorization with provided jwt
    const authMock = vi.spyOn(AuthService.prototype, 'authorization').mockResolvedValue(jwt)
    // controller callback
    const result = await cb()
    // undo AuthService mocking
    authMock.mockReset()
    return result
  }

  /**
   * Mocks a GET request.
   */
  async testGet<E extends keyof ApiGetEndpoints>(
    endpoint: E,
    options: BanEmpty<ApiGetOptions<E>>,
    jwt: JwtPayload | null = null,
  ): Promise<{
    status: number
    body: ApiGetEndpoints[E]['response']
  }> {
    return this.withMockedAuth(() => {
      // @ts-expect-error params
      return this.request.get(this.buildEndpoint(endpoint, options?.params))
    }, jwt)
  }

  /**
   * Mocks a POST request.
   */
  async testPost<E extends keyof ApiPostEndpoints>(
    endpoint: E,
    options: BanEmpty<ApiPostOptions<E>>,
    jwt: JwtPayload | null = null,
  ): Promise<{
    status: number
    body: ApiPostEndpoints[E]['response']
  }> {
    return this.withMockedAuth(() => {
      return (
        this.request
          // @ts-expect-error params
          .post(this.buildEndpoint(endpoint, options?.params))
          // @ts-expect-error body
          .send((options.body as object) ?? undefined)
          .set('Content-Type', 'application/json')
          .set('Accept', 'application/json')
      )
    }, jwt)
  }

  // Equivalent to ApiService.buildUrl except it doesn't prepend `apiBase`,
  // because for tests to work the endpoint has to fully match (i.e. no
  // additional stuff may be pre- or appended).
  buildEndpoint(endpoint: string, params?: Record<string, string>) {
    if (params) {
      endpoint = interpolateEndpoint(endpoint, params)
    }
    return endpoint
  }
}

/**
 * Creates services used in controllers.
 */
export function setupControllerTestEnvironment(config: configuration) {
  CeleryService.create(config)
  AuthService.create(config)
  SqlService.create(config)
}
