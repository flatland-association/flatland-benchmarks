import type { Request } from 'express'
import jwt from 'jsonwebtoken'
import { JwksClient } from 'jwks-rsa'
import { beforeAll, describe, expect, test, vi } from 'vitest'
import { defaults } from '../config/defaults.mjs'
import { AuthService } from './auth-service.mjs'

const AUTHSERVICE_TIMEOUT = 30 * 1000 // ms

describe('Auth Service', () => {
  // using a string as secret results in symmetrical algorithm being used, i.e.
  // the same secret can be used for signing and verifying
  const testSecret = 'secret'

  const getToken = (options?: { lifetime?: number; secret?: string }) => {
    return jwt.sign(
      {
        exp: Math.floor(Date.now() / 1000) + (options?.lifetime ?? 60),
        data: 'test',
      },
      options?.secret ?? testSecret,
    )
  }

  beforeAll(async () => {
    const testConfig = Object.assign({}, defaults)
    // redirect to unreachable url
    testConfig.keycloak.url = '0.0.0.0:1'
    AuthService.create(testConfig)
  })

  test.each([
    {
      should: 'should reject missing token',
      mockStore: false,
      token: undefined,
      auth: false,
      error: undefined,
    },
    {
      should: 'should reject if service is unavailable',
      mockStore: false,
      token: getToken(),
      auth: false,
      error: 'error in secret or public key callback',
    },
    {
      should: 'should reject invalid token',
      mockStore: true,
      token: 'not-a-token',
      auth: false,
      error: 'jwt malformed',
    },
    {
      should: 'should reject forged token',
      mockStore: true,
      token: getToken({ secret: 'not-the-test-secret' }),
      auth: false,
      error: 'invalid signature',
    },
    {
      should: 'should reject expired token',
      mockStore: true,
      token: getToken({ lifetime: -60 }),
      auth: false,
      error: 'jwt expired',
    },
    // testing this last also ensures `authService.error` gets properly reset
    {
      should: 'should accept valid token',
      mockStore: true,
      token: getToken(),
      auth: true,
      error: undefined,
    },
  ])(
    '$should',
    async (testCase) => {
      const authService = AuthService.getInstance()
      if (testCase.mockStore) {
        // mock JwksClient to return a storage that returns test secret as key
        // @ts-expect-error argument
        vi.spyOn(JwksClient.prototype, 'getSigningKey').mockResolvedValueOnce({ getPublicKey: () => testSecret })
      }
      // mock an incoming request with test case's token
      const req = {
        headers: {},
      } as Request
      if (testCase.token) {
        req.headers.authorization = `Bearer ${testCase.token}`
      }
      //... and try authorizing with that
      const auth = await authService.authorization(req)
      if (testCase.auth) {
        expect(auth).toBeTruthy()
        expect(auth!['data']).toBe('test')
      } else {
        expect(auth).toBeFalsy()
      }
      if (testCase.error) {
        expect(authService.error?.message).toMatch(testCase.error)
      } else {
        expect(authService.error).toBeUndefined()
      }
    },
    { timeout: AUTHSERVICE_TIMEOUT },
  )
})
