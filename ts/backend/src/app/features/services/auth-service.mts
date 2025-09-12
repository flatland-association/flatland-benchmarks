import type { Request } from 'express'
import jwt, { JwtPayload, VerifyCallback } from 'jsonwebtoken'
import { JwksClient } from 'jwks-rsa'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { Service } from './service.mjs'

const logger = new Logger('auth-service')

export class AuthService extends Service {
  private publicKey?: string

  /**
   * `VerifyErrors` that occurred during `authorization`. Is reset to
   * `undefined` upon invoking `authorization`.
   */
  error?: jwt.VerifyErrors

  constructor(config: configuration) {
    super(config)
  }

  // Used in jwt.verify to get the public key used to verify the JWT.
  // The pkey is either taken from cache or retrieved from the open id endpoint
  // and then cached.
  private getKey = (header: jwt.JwtHeader, callback: jwt.SigningKeyCallback) => {
    if (this.publicKey) {
      callback(null, this.publicKey)
      return
    }

    // as-per-standard uri where JWT key set can be found
    const jwksUri = `${this.config.keycloak.url}/realms/${this.config.keycloak.realm}/protocol/openid-connect/certs`
    logger.info(`fetching public key from  ${jwksUri}`)
    // get the public key for the JWT in question
    const client = new JwksClient({ jwksUri, timeout: this.config.keycloak.timeout })
    client
      .getSigningKey(header.kid)
      .then((key) => {
        this.publicKey = key.getPublicKey()
        callback(null, this.publicKey)
        logger.info(`fetched public key from  ${jwksUri}`)
      })
      .catch((err) => {
        callback(err)
        logger.error(`failed fetching public key from  ${jwksUri}: ${JSON.stringify(err)}`)
      })
  }

  /**
   * Returns authorization details (plain object) if client provided a valid
   * authorization token and `null` if they didn't.
   * If the provided token can not be verified, an error will be thrown.
   * @param req Request object to extract authorization header from.
   */
  async authorization(req: Request) {
    this.error = undefined
    logger.debug(`authorizing token for request on ${req.method} ${req.originalUrl}`)

    const token = req.headers.authorization?.split(' ')[1]

    if (!token) return null

    return new Promise<JwtPayload | null>((resolve) => {
      const verifyCallback: VerifyCallback<JwtPayload | string> = (
        error: jwt.VerifyErrors | null,
        decoded: string | JwtPayload | undefined,
      ): void => {
        if (error) {
          this.error = error
          logger.error(`token verification for request on ${req.method} ${req.originalUrl} failed: ${error} `)
          return resolve(null)
        }
        logger.debug(`token verification successful for request on ${req.method} ${req.originalUrl}.`)
        logger.trace(`authenticated subject ${(decoded as JwtPayload).sub}`)
        return resolve(decoded as JwtPayload)
      }
      logger.debug(`verifying token for request on ${req.method} ${req.originalUrl}`)
      jwt.verify(token, this.getKey, { audience: this.config.keycloak.audience }, verifyCallback)
    })
  }
}
