import type { Request } from 'express'
import jwt from 'jsonwebtoken'
import { JwksClient } from 'jwks-rsa'
import { beforeAll, describe, expect, test, vi } from 'vitest'
import { defaults } from '../config/defaults.mjs'
import { AuthService } from './auth-service.mjs'

describe('Auth Service', () => {
  // using a string as secret results in symmetric algorithm being used, i.e.
  // the same secret can be used for signing and verifying, which is ideal for
  // this test as it simplifies the signing/verifying process but still allows
  // to test against forged tokens  by using another secret.
  const testSecret = 'secret'
  const testJwtPayload = {
    aud: 'test-audience',
    data: 'test',
  }

  const getToken = (options?: {
    lifetime?: number
    secret?: string
    payloadOverrides?: Partial<typeof testJwtPayload>
  }) => {
    // create a jwt with test payload, extended with expiration date, and sign
    // it with provided or testing secret
    return jwt.sign(
      {
        exp: Math.floor(Date.now() / 1000) + (options?.lifetime ?? 60),
        ...testJwtPayload,
        ...options?.payloadOverrides,
      },
      options?.secret ?? testSecret,
    )
  }

  beforeAll(async () => {
    const testConfig = Object.assign({}, defaults)
    // redirect to unreachable url
    testConfig.keycloak.url = '0.0.0.0:1'
    // make sure aud claim matches test
    testConfig.keycloak.audience = testJwtPayload.aud
    // fail faster
    testConfig.keycloak.timeout = 1000
    AuthService.create(testConfig)
  })

  test.each([
    {
      should: 'should reject missing token',
      mockStore: false,
      token: undefined,
      expectedAuth: null,
      expectedError: undefined,
    },
    {
      should: 'should reject if service is unavailable',
      mockStore: false,
      token: getToken(),
      expectedAuth: null,
      expectedError: 'error in secret or public key callback',
    },
    {
      should: 'should reject invalid token',
      mockStore: true,
      token: 'not-a-token',
      expectedAuth: null,
      expectedError: 'jwt malformed',
    },
    {
      should: 'should reject forged token',
      mockStore: true,
      token: getToken({ secret: 'not-the-test-secret' }),
      expectedAuth: null,
      expectedError: 'invalid signature',
    },
    {
      should: 'should reject expired token',
      mockStore: true,
      token: getToken({ lifetime: -60 }),
      expectedAuth: null,
      expectedError: 'jwt expired',
    },
    {
      should: 'should reject token with audience mismatch',
      mockStore: true,
      token: getToken({ payloadOverrides: { aud: 'not-test-audience' } }),
      expectedAuth: null,
      expectedError: 'jwt audience invalid',
    },
    // testing this last also ensures `authService.error` gets properly reset
    {
      should: 'should accept valid token',
      mockStore: true,
      token: getToken(),
      expectedAuth: testJwtPayload,
      expectedError: undefined,
    },
  ])('$should', async (testCase) => {
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
    if (testCase.expectedAuth) {
      expect(auth).toBeTruthy()
      // there will be additional jwt fields - do not test those
      expect(auth!['data']).toBe(testJwtPayload.data)
    } else {
      expect(auth).toBeFalsy()
    }
    if (testCase.expectedError) {
      expect(authService.error?.message).toMatch(testCase.expectedError)
    } else {
      expect(authService.error).toBeUndefined()
    }
  })
})
