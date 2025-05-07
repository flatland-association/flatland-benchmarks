import { beforeAll, describe, expect, MockInstance, test, vi } from 'vitest'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import { S3Service } from '../../src/app/features/services/s3-service.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('S3 Service (with MinIO container)', () => {
  // create new test file contents for each test run to avoid passing the reading test when the storing test failed
  const testFileContents = Date.now().toString()

  let loggerErrorMock: MockInstance

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    testConfig.s3.path = 'test'
    S3Service.create(testConfig)
  })

  beforeEach(() => {
    loggerErrorMock = vi.spyOn(Logger.prototype, 'error')
  })

  afterEach(() => {
    loggerErrorMock.mockReset()
  })

  test('should store a file and report success', async () => {
    const minio = S3Service.getInstance()
    const result = await minio.putFileContents('test.txt', testFileContents)
    expect(result?.ETag).toBeTruthy()
  })

  test('should report errors when unsuccessfully storing a file', async () => {
    const minio = S3Service.getInstance()
    const result = await minio.putFileContents('..', testFileContents)
    expect(result).toBeUndefined()
    expect(loggerErrorMock).toBeCalledTimes(1)
  })

  test('should error when getting stats of inexistent file', async () => {
    const minio = S3Service.getInstance()
    const result = await minio.getFileStat('not-test.txt')
    expect(result).toBeUndefined()
    expect(loggerErrorMock).toBeCalledTimes(1)
  })

  test('should not error when getting stats of inexistent file with probing', async () => {
    const minio = S3Service.getInstance()
    const result = await minio.getFileStat('not-test.txt', true)
    expect(result).toBeUndefined()
    expect(loggerErrorMock).toBeCalledTimes(0)
  })

  test('should return stats of existent file', async () => {
    const minio = S3Service.getInstance()
    const result = await minio.getFileStat('test.txt')
    expect(result?.ETag).toBeTruthy()
    expect(result?.LastModified).toBeTruthy()
    expect(result?.Metadata).toBeTruthy()
    expect(result?.ContentLength).toBeTruthy()
  })

  test('should error when getting contents of inexistent file', async () => {
    const minio = S3Service.getInstance()
    const result = await minio.getFileContents('not-test.txt')
    expect(result).toBeUndefined()
    expect(loggerErrorMock).toBeCalledTimes(1)
  })

  test('should return contents of existent file', async () => {
    const minio = S3Service.getInstance()
    const result = await minio.getFileContents('test.txt')
    expect(result).toBe(testFileContents)
  })
})
