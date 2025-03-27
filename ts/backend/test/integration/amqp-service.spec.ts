import { MockInstance } from 'vitest'
import { defaults } from '../../src/app/features/config/defaults.mjs'
import { AmqpService } from '../../src/app/features/services/amqp-service.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('AMQP Service', () => {
  describe('offline', () => {
    let onErrorSpy: MockInstance

    beforeAll(async () => {
      // take default config but re-route to unreachable port to trigger error
      const myConfig = Object.assign({}, defaults)
      myConfig.amqp.port = 1
      AmqpService.create(myConfig)
      onErrorSpy = vi.spyOn(AmqpService.prototype, 'onError')
    })

    afterAll(() => {
      onErrorSpy.mockReset()
    })

    // This does not cover the case where an established connection vanishes!
    test('should report and reset on connection failure', async () => {
      const amqp = AmqpService.getInstance()
      const channel = await amqp.getChannel()
      expect(channel).toBeUndefined()
      // assert report
      expect(onErrorSpy).toBeCalledTimes(1)
      // assert reset
      expect(amqp.channel).toBeUndefined()
      expect(amqp.channelPromise).toBeUndefined()
    })

    test('should indicate message could not be queued', async () => {
      const amqp = AmqpService.getInstance()
      const result = await amqp.sendToQueue('test', { text: 'test' })
      expect(result).toBeFalsy()
    })
  })

  describe('online', () => {
    beforeAll(async () => {
      const testConfig = await getTestConfig()
      AmqpService.create(testConfig)
    })

    test('should queue a message', async () => {
      const amqp = AmqpService.getInstance()
      const channel = await amqp.getChannel()
      expect(channel).toBeTruthy()
      const result = await amqp.sendToQueue('test', { text: 'test' })
      expect(result).toBeTruthy()
    })
  })
})
