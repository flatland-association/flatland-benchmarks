import { configuration } from '../config/config.mjs'
import { CeleryService } from '../services/celery-client-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { Controller, dbgRequestObject, GetHandler, PatchHandler, PostHandler } from './controller.mjs'
import { Logger } from '../logger/logger.mjs'

const logger = new Logger('debug-controller')

export class HealthController extends Controller {
  constructor(config: configuration) {
    super(config)
    this.attachGet('/health/live', this.getHealth)
  }

  getHealth: GetHandler<'/health/live'> = async (req, res) => {
    // try running query
    const sql = SqlService.getInstance()
    await sql.query`SELECT * FROM field_definitions`
    .catch(function (err) {
        logger.error(`Received error from queue:${err}`);
        this.serverError(res, err)
    });
    if(sql.errors != undefined){
      this.serverError(res, sql.errors)
    }

    // send message to debug queue
    const celery = CeleryService.getInstance()
    const task = celery.isReady()
    await task
    .then(result => {
       this.respond(res, "ready", dbgRequestObject(req));
     })
    .catch((err) => {
      logger.error(`Received error from queue:${err}`);
      this.serverError(res, "failed")
    })
  }
}
