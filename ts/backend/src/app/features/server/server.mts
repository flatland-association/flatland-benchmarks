import cors from 'cors'
import type { Express } from 'express'
import express from 'express'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { router } from './router.mjs'

const logger = new Logger('server')

export class Server {
  app: Express

  /**
   * Creates a new server.
   * @param config Configuration to use
   */
  constructor(public config: configuration) {
    // start express server
    this.app = express()
    // enable CORS
    this.app.use(cors())
    // only communicate in JSON on public API
    this.app.use(express.json())

    // use routes from router
    this.app.use(router(this))

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    this.app.use((err: any, _req: unknown, res: any, next: any) => {
      if (!err) {
        return next()
      }

      logger.error('Handled exception, responded with 500:', err)
      res.status(500)
      res.send('500: Internal server error')
    })

    // start listening
    this.app.listen(this.config.api.port, this.config.api.host, () => {
      logger.info(`Server is now live on ${this.config.api.host}:${this.config.api.port}`)
    })
  }
}
