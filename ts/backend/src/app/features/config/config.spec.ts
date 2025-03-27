import JSON5 from 'json5'
import { afterEach, beforeEach, describe, expect, MockInstance, test, vi } from 'vitest'
import { Logger } from '../logger/logger.mjs'
import { loadConfig } from './config.mjs'
import { defaults } from './defaults.mjs'

describe('Config', () => {
  let loggerWarnMock: MockInstance

  beforeEach(() => {
    loggerWarnMock = vi.spyOn(Logger.prototype, 'warn')
  })

  afterEach(() => {
    loggerWarnMock.mockReset()
  })

  test('should fall back to defaults', () => {
    const config = loadConfig('should-not-exist.jsonc')
    expect(loggerWarnMock).toHaveBeenCalled()
    expect(config).toEqual(defaults)
  })

  // not necessarily an error if they don't match, but it would raise questions
  // about what the actual defaults would be
  test('should load config.json matching defaults', () => {
    const json5ParseMock = vi.spyOn(JSON5, 'parse')
    // in test, it's relative to where vitest.config lives + ../config
    const config = loadConfig('../backend/src/config/config.jsonc')
    // ensure file was loaded from disk
    expect(json5ParseMock).toBeCalledTimes(1)
    // ensure contents are fine
    expect(config).toEqual(defaults)
  })
})
