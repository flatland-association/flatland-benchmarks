import { json } from '@common/utility-types.mjs'
import amqp from 'amqplib'
import { configuration } from '../config/config.mjs'

const instances = new Map<string, AmpqService>()

// // eslint-disable-next-line @typescript-eslint/no-explicit-any
// export type json = any

// TODO: base class Service with getInstance() and just hack together late static binding FFS

/**
 * Service class providing common AMQP functionality.
 */
export class AmpqService {
  // default is always available
  /**
   * Returns a previously constructed instance of `AmpqService`.
   * @returns Default `AmpqService` instance.
   */
  static getInstance(): AmpqService

  //... others might not necessarily be
  /**
   * Returns a previously constructed instance of `AmpqService`.
   * @param ident Instance identifier.
   * @returns A `AmpqService` instance or `undefined` when an un-constructed instance was requested.
   */
  static getInstance(ident: string): AmpqService | undefined

  static getInstance(ident = 'default') {
    return instances.get(ident)
  }

  channelPromise

  constructor(
    public config: configuration,
    ident = 'default',
  ) {
    instances.set(ident, this)

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
