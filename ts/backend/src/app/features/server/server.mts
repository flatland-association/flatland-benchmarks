import ansiStyles from 'ansi-styles'
import cors from 'cors'
import type { Express } from 'express'
import express from 'express'
import { configuration } from '../config/config.mjs'
import { router } from './router.mjs'

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

      console.log(`${ansiStyles.red.open}Handled exception, responded with 500:${ansiStyles.reset.close}`)
      console.log(err)
      res.status(500)
      res.send('500: Internal server error')
    })

    // start listening
    this.app.listen(this.config.api.port, this.config.api.host, () => {
      console.log(
        `${ansiStyles.green.open}server is now live on ${this.config.api.host}:${this.config.api.port}${ansiStyles.reset.close}`,
      )
    })
  }
}
