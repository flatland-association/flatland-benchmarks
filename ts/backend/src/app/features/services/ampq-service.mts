import { json } from '@common/utility-types.mjs'
import amqp from 'amqplib'
import { configuration } from '../config/config.mjs'
import { Service } from './service.mjs'

/**
 * Service class providing common AMQP functionality.
 */
export class AmpqService extends Service {
  channelPromise

  constructor(config: configuration) {
    super(config)

    this.channelPromise = amqp.connect(`amqp://${this.config.amqp.host}:${this.config.amqp.port}`).then((conn) => {
      return conn.createChannel()
    })
  }

  /**
   * Asynchronously returns the ampq channel.
   * @see {@link https://amqp-node.github.io/amqplib/channel_api.html#channel | amqp.Channel}
   */
  getChannel() {
    return this.channelPromise
  }

  /**
   * Sends data to ampq queue.
   * @param queue Name of the queue.
   * @param data Data to send.
   * @param options Publish options.
   * @returns `true` on success.
   * @see {@link https://amqp-node.github.io/amqplib/channel_api.html#channel_sendToQueue | ampq.Channel.sendToQueue}
   */
  async sendToQueue(queue: string, data: json, options?: amqp.Options.Publish) {
    const channel = await this.getChannel()
    await channel.assertQueue(queue, { durable: true })
    return channel.sendToQueue(queue, Buffer.from(JSON.stringify(data)), options)
  }
}
