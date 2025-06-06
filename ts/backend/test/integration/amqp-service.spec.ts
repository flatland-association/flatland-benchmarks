import { AmqpService } from '../../src/app/features/services/amqp-service.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('AMQP Service', () => {
  describe('online', () => {
    beforeAll(async () => {
      const testConfig = await getTestConfig()
      AmqpService.create(testConfig)
    })

    test('should queue a message', async () => {
      const amqp = AmqpService.getInstance()
      const result = await amqp.sendToQueue('queue', { text: 'test' }, 'submissionUUID')
      expect(result).toBeTruthy()
    })
  })
})
