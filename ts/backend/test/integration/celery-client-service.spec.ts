import { CeleryService } from '../../src/app/features/services/celery-client-service.mjs'
import { getTestConfig } from './setup.mjs'
import { expect, test } from 'vitest'

describe.sequential('Celery client Service', () => {
  describe('online', () => {
    beforeAll(async () => {
      const testConfig = await getTestConfig()
      CeleryService.create(testConfig)
    })

    test('should queue a message', async () => {
      const celery = CeleryService.getInstance()
      const result = await celery.sendTask('queue', { text: 'test' }, 'submissionUUID')
      expect(result).toBeTruthy()
    })
  })
})
