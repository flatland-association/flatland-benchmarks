import { ApiGetEndpoints } from '@common/api-endpoints'
import { ApiGetOptions } from '@common/api-types'
import { interpolateEndpoint } from '@common/endpoint-utils'
import { BanEmpty } from '@common/utility-types'
import type { Express } from 'express'
import express from 'express'
import supertest from 'supertest'
import TestAgent from 'supertest/lib/agent'
import { expect } from 'vitest'
import { configuration } from '../src/app/features/config/config.mjs'
import { Controller } from '../src/app/features/controller/controller.mjs'

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
    this.request = supertest(this.app)
    this.app.use(this.controller.router)
  }

  /**
   * Mocks a GET request.
   */
  async testGet<E extends keyof ApiGetEndpoints>(
    endpoint: E,
    options: BanEmpty<ApiGetOptions<E>>,
  ): Promise<{
    status: number
    body: ApiGetEndpoints[E]['response']
  }> {
    // @ts-expect-error params
    return this.request.get(this.buildEndpoint(endpoint, options?.params))
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
