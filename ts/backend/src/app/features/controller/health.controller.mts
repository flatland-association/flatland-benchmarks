import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { CeleryService } from '../services/celery-client-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

const logger = new Logger('health-controller')

export class HealthController extends Controller {
  constructor(config: configuration) {
    super(config)
    this.attachGet('/health/live', this.getHealth)
  }

  /**
   * https://download.eclipse.org/microprofile/microprofile-health-2.1/microprofile-health-spec.html#_constructing_healthcheckresponse_s
   * @swagger
   * /health/live:
   *  get:
   *    description: Returns liveness.
   *    responses:
   *      200:
   *        description: Live
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: object
   *                      properties:
   *                        status:
   *                          type: string
   *                        checks:
   *                          type: array
   *                          items:
   *                            type: object
   *                            properties:
   *                              name:
   *                                type: string
   *                              status:
   *                                type: string
   *                              data:
   *                                type: string
   */
  getHealth: GetHandler<'/health/live'> = async (req, res) => {
    const payload = {
      status: 'UP',
      checks: [
        {
          name: 'SqlService',
          status: 'UP',
        },
        {
          name: 'CeleryService',
          status: 'UP',
        },
      ],
    }
    // try running query
    const sql = SqlService.getInstance()
    await sql.query`SELECT * FROM fields`.catch(function (err) {
      logger.error(`Received error from SqlService:${err}`)
      payload['status'] = 'DOWN'
      payload['checks'][0]['status'] = 'DOWN'
    })

    // send message to debug queue
    const celery = CeleryService.getInstance()
    const task = celery.isReady()
    await task.catch((err) => {
      logger.error(`Received error from queue:${err}`)
      payload['status'] = 'DOWN'
      payload['checks'][1]['status'] = 'DOWN'
    })

    if (payload['status'] == 'UP') {
      this.respond(req, res, payload)
    } else {
      this.respondError(req, res, { text: 'Service unavailable' }, payload, undefined, 503)
    }
  }
}
