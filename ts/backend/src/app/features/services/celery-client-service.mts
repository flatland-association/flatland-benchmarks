import { json } from '@common/utility-types.js'
import celery from 'celery-node'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { Service } from './service.mjs'
import amqp from 'amqplib'

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
   * @param options Publish options.
   * @returns `true` on success.
   */
  async sendTask(benchmarkId: string, payload: json, uuid: string) {
    const client = celery.createClient(
      `amqp://${this.config.amqp.host}:${this.config.amqp.port}`,
      `amqp://${this.config.amqp.host}:${this.config.amqp.port}`,
      benchmarkId,
    )
    const result = client.sendTask(benchmarkId, [], payload, `sub-${uuid}`)
    result.get().then((data) => {
      logger.info('Received result from queue:')
      logger.info(data)
      client.disconnect().then(() => {
        done()
      })
    })
    return true
  }

  /**
   * Sends data to Celery. https://github.com/actumn/celery.node/blob/5a1a412955ae757cf0bd36015a15f5b7d18c69eb/src/app/client.ts#L135
   * @param benchmarkId Benchmark ID (equals Celery task name by convention).
   * @param payload Data to send.
   * @param options Publish options.
   * @returns {Promise} promise that continues if backend and broker connected.
   */
   // TODO use celery.createClient(...).isReady() instead
    async isReady(): Promise<any> {
        return amqp.connect(`amqp://${this.config.amqp.host}:${this.config.amqp.port}`)
    }
}
