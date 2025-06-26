import celery from 'celery-node'
import { CeleryService } from '../../src/app/features/services/celery-client-service.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Celery client Service', () => {
  describe('online', () => {
    test('should queue a message', async () => {
      const testConfig = await getTestConfig()
      const worker = celery.createWorker(
        `amqp://${testConfig.amqp.host}:${testConfig.amqp.port}`,
        `amqp://${testConfig.amqp.host}:${testConfig.amqp.port}`,
        // we have have task name == queue name == benchmarkId in FAB
        'benchmarkId',
      )
      CeleryService.create(testConfig)
      const celeryService = CeleryService.getInstance()
      worker.register('benchmarkId', () => 'fancy')
      worker.start()
      // sendTask returns the return value from the task
      const result = await celeryService.sendTask('benchmarkId', { text: 'test' }, 'submissionUUID')
      expect(result).toEqual('fancy')
    })
  })
  describe('offline', () => {
    beforeAll(async () => {
      const testConfig = await getTestConfig()
      testConfig.amqp.host = 'nix.amqp.com'
      testConfig.amqp.port = 2
      CeleryService.create(testConfig)
    })

    test('should fail', async ({ expect }) => {
      const celeryService = CeleryService.getInstance()
      // sendTask fails fast when connection to broker fails
      await expect(() => celeryService.sendTask('queue', { text: 'test' }, 'submissionUUID')).rejects.toThrowError(
        /^getaddrinfo ENOTFOUND nix.amqp.com$/,
      )
    })
  })
})
