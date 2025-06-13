import { CeleryService } from '../../src/app/features/services/celery-client-service.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Celery client Service', () => {
  describe('online', () => {
    beforeAll(async () => {
      const testConfig = await getTestConfig()
      CeleryService.create(testConfig)
    })

    test('should queue a message', async () => {
      const amqp = CeleryService.getInstance()
      const result = await amqp.sendToQueue('queue', { text: 'test' }, 'submissionUUID')
      expect(result).toBeTruthy()
    })
  })
})
