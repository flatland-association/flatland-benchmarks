import type { Request } from 'express'
import jwt, { JwtPayload, VerifyCallback } from 'jsonwebtoken'
import { JwksClient } from 'jwks-rsa'
import { configuration } from '../config/config.mjs'
import { Service } from './service.mjs'

export class AuthService extends Service {
  private publicKey?: string

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
    // get the public key for the JWT in question
    const client = new JwksClient({ jwksUri })
    client
      .getSigningKey(header.kid)
      .then((key) => {
        this.publicKey = key.getPublicKey()
        callback(null, this.publicKey)
      })
      .catch((err) => {
        callback(err)
      })
  }

  /**
   * Returns authorization details (plain object) if client provided a valid
   * authorization token and `null` if they didn't.
   * If the provided token can not be verified, an error will be thrown.
   * @param req Request object to extract authorization header from.
   */
  async authorization(req: Request) {
    const token = req.headers.authorization?.split(' ')[1]

    if (!token) return null

    return new Promise<JwtPayload>((resolve, reject) => {
      const verifyCallback: VerifyCallback<JwtPayload | string> = (
        error: jwt.VerifyErrors | null,
        decoded: string | JwtPayload | undefined,
      ): void => {
        if (error) {
          return reject(error)
        }
        return resolve(decoded as JwtPayload)
      }

      jwt.verify(token, this.getKey, verifyCallback)
    })
  }
}
