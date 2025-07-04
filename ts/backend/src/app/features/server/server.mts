import cors from 'cors'
import type { Express } from 'express'
import express from 'express'
import fs from 'node:fs/promises'
import * as swaggerUi from 'swagger-ui-express'
import swaggerDocument from '../../../swagger/swagger.json'
import { configuration } from '../config/config.mjs'
import { BenchmarkGroupController } from '../controller/benchmark-group.controller.mjs'
import { BenchmarkController } from '../controller/benchmark.controller.mjs'
import { DebugController } from '../controller/debug.controller.mjs'
import { HealthController } from '../controller/health.controller.mjs'
import { ResultsController } from '../controller/results.controller.mjs'
import { ScenarioController } from '../controller/scenario.controller.mjs'
import { SubmissionController } from '../controller/submission.controller.mjs'
import { TestController } from '../controller/test.controller.mjs'
import { Logger } from '../logger/logger.mjs'

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

    // use routes from controllers
    this.app.use(new DebugController(this.config).router)
    this.app.use(new HealthController(this.config).router)
    this.app.use(new BenchmarkController(this.config).router)
    this.app.use(new BenchmarkGroupController(this.config).router)
    this.app.use(new TestController(this.config).router)
    this.app.use(new ScenarioController(this.config).router)
    this.app.use(new SubmissionController(this.config).router)
    this.app.use(new ResultsController(this.config).router)

    // serve public files from public with /public path prefix
    fs.stat('../public')
      .then((_stats) => {
        this.app.use('/public', express.static('../public'))
        logger.info('Serving static files under /public')
      })
      .catch((reason) => {
        logger.fatal('Unable to serve static files', reason)
      })

    // use swagger as apidoc
    this.app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument))

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
    this.app.listen(this.config.api.port, this.config.api.host, (error) => {
      if (typeof error === 'undefined') {
        logger.info(`Server is now live on ${this.config.api.host}:${this.config.api.port}`)
      } else {
        logger.fatal(`Server could not be started on ${this.config.api.host}:${this.config.api.port}`, error.message)
        process.exit(1)
      }
    })
  }
}
