import { json } from '@common/utility-types.js'
import amqp from 'amqplib'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { Service } from './service.mjs'

const logger = new Logger('amqp')

/**
 * Service class providing common AMQP functionality.
 */
export class AmqpService extends Service {
  channelPromise?: Promise<amqp.Channel | undefined>
  channel?: amqp.Channel

  constructor(config: configuration) {
    super(config)

    // try connecting on startup
    this.getChannel()
  }

  onError(err: unknown) {
    logger.error(err as string)
    this.channel = undefined
    this.channelPromise = undefined
    return undefined
  }

  /**
   * Asynchronously returns the amqp channel.
   * @see {@link https://amqp-node.github.io/amqplib/channel_api.html#channel | amqp.Channel}
   */
  async getChannel() {
    // except for weird runtime conditions, channel should be valid as long as it's truthy
    if (this.channel) return this.channel
    if (this.channelPromise) return this.channelPromise

    this.channelPromise = amqp
      .connect(`amqp://${this.config.amqp.host}:${this.config.amqp.port}`)
      .then(async (conn) => {
        conn.on('error', (err) => {
          this.onError(err)
        })
        conn.on('close', () => {
          this.onError('socket closed')
        })
        return conn.createChannel()
      })
      .catch((err) => this.onError(err))

    this.channelPromise.then((c) => {
      this.channel = c
    })

    return this.channelPromise
  }

  /**
   * Sends data to amqp queue.
   * @param queue Name of the queue.
   * @param data Data to send.
   * @param options Publish options.
   * @returns `true` on success.
   * @see {@link https://amqp-node.github.io/amqplib/channel_api.html#channel_sendToQueue | amqp.Channel.sendToQueue}
   */
  async sendToQueue(queue: string, data: json, options?: amqp.Options.Publish) {
    await this.getChannel()
    await this.channel?.assertQueue(queue, { durable: true }).catch((err) => this.onError(err))
    return this.channel?.sendToQueue(queue, Buffer.from(JSON.stringify(data)), options) ?? false
  }
}
