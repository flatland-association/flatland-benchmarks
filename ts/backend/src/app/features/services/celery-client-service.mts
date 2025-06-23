import { json } from '@common/utility-types.js'
import amqp from 'amqplib'
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
   * Sends data to Celery. https://github.com/actumn/celery.node/blob/5a1a412955ae757cf0bd36015a15f5b7d18c69eb/src/app/client.ts#L135
   * @param benchmarkId Benchmark ID (equals Celery task name by convention).
   * @param payload Data to send.
   * @param uuid SubmissionID
   * @returns Promise of task result if connection to broker = backend can be established.
   */
  async sendTask(benchmarkId: string, payload: json, uuid: string) {
    // fail fast if not connected
    await this.isReady()
    const client = celery.createClient(
      `amqp://${this.config.amqp.host}:${this.config.amqp.port}`,
      `amqp://${this.config.amqp.host}:${this.config.amqp.port}`,
      // queue
      benchmarkId,
    )
    console.log(`Sending payload ${payload} to amqp://${this.config.amqp.host}:${this.config.amqp.port}`)
    const result = client.sendTask(
      benchmarkId, // taskName: string,
      [], // args?: Array<any>,
      payload, // kwargs?: object,
      uuid, //     taskId?: string
    )
    console.log(`Sent task to amqp://${this.config.amqp.host}:${this.config.amqp.port}`)
    // return promise
    return result.get().then((data) => {
      console.log(`Received result from queue: ${data}`)
      client.disconnect()
      return data
    })
  }

  /**
   * Checks whether connection to broker = backend is possible.
   * @param benchmarkId Benchmark ID (equals Celery task name by convention).
   * @param payload Data to send.
   * @param options Publish options.
   * @returns {Promise} promise that continues if backend and broker connected.
   */
  // TODO use celery.createClient(...).isReady() instead
  // https://github.com/actumn/celery.node/blob/5a1a412955ae757cf0bd36015a15f5b7d18c69eb/src/app/client.ts#L135
  async isReady(): Promise {
    return amqp.connect(`amqp://${this.config.amqp.host}:${this.config.amqp.port}`)
  }
}
