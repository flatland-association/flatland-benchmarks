import { json } from '@common/utility-types.js'
import amqp from 'amqplib'
import ansiStyles from 'ansi-styles'
import { configuration } from '../config/config.mjs'
import { Service } from './service.mjs'

/**
 * Service class providing common AMQP functionality.
 */
export class AmpqService extends Service {
  channelPromise?: Promise<void>
  channel?: amqp.Channel

  constructor(config: configuration) {
    super(config)

    // try connecting on startup
    this.getChannel()
  }

  onError(err: unknown) {
    console.log(`\n${ansiStyles.red.open}AMPQ Service error${ansiStyles.reset.close}`)
    console.log(err)
    console.log('\n')
    this.channel = undefined
    return undefined
  }

  /**
   * Asynchronously returns the ampq channel.
   * @see {@link https://amqp-node.github.io/amqplib/channel_api.html#channel | amqp.Channel}
   */
  async getChannel() {
    // except for weird runtime conditions, channel should be valid as long as it's truthy
    if (this.channel) return this.channel

    this.channel = await amqp
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

    return this.channel
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
    await this.getChannel()
    await this.channel?.assertQueue(queue, { durable: true }).catch((err) => this.onError(err))
    return this.channel?.sendToQueue(queue, Buffer.from(JSON.stringify(data)), options) ?? false
  }
}
