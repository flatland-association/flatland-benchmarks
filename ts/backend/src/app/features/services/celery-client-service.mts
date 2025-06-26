import { json } from '@common/utility-types'
import celery from 'celery-node'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { Service } from './service.mjs'

const logger = new Logger('celery-service')

/**
 * Service class providing common Celery client functionality.
 */
export class CeleryService extends Service {
  constructor(config: configuration) {
    super(config)
  }

  /**
   * Creates and returns a new Celery client.
   * @param benchmarkId Benchmark ID (equals Celery task name by convention).
   * @returns Celery client.
   */
  getClient(benchmarkId?: string) {
    return celery.createClient(
      `amqp://${this.config.amqp.host}:${this.config.amqp.port}`,
      `amqp://${this.config.amqp.host}:${this.config.amqp.port}`,
      // queue
      benchmarkId,
    )
  }

  /**
   * Sends data to Celery. https://github.com/actumn/celery.node/blob/5a1a412955ae757cf0bd36015a15f5b7d18c69eb/src/app/client.ts#L135
   * @param benchmarkId Benchmark ID (equals Celery task name by convention).
   * @param payload Data to send.
   * @param uuid SubmissionID
   * @returns Promise of task result if connection to broker = backend can be established.
   */
  async sendTask(benchmarkId: string, payload: object, uuid: string) {
    // fail fast if not connected
    const client = this.getClient(benchmarkId)
    // try...catch because celery-node doesn't catch all rejections that can
    // occur during sendTask and then those propagate and must be caught in user
    // code...
    try {
      return client
        .isReady()
        .then(() => {
          console.log(`Sending payload ${payload} to amqp://${this.config.amqp.host}:${this.config.amqp.port}`)
          const result = client.sendTask(
            benchmarkId, // taskName: string,
            [], // args?: Array<any>,
            payload, // kwargs?: object,
            uuid, //     taskId?: string
          )
          console.log(`Sent task to amqp://${this.config.amqp.host}:${this.config.amqp.port}`)
          // return promise
          return result
            .get()
            .then((data) => {
              console.log(`Received result from queue: ${data}`)
              client.disconnect()
              return data
            })
            .catch((error) => {
              logger.error('get result failed:', error)
              return Promise.reject(error)
            })
        })
        .catch((error) => {
          logger.error('isReady failed:', error)
          return Promise.reject(error)
        })
    } catch (error) {
      logger.error('sendTask failed:', error as json)
      return Promise.reject(error)
    }
  }
}
