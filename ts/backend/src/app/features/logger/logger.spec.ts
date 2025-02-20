import ansiStyles from 'ansi-styles'
import { beforeAll, describe, expect, it, MockInstance, vi } from 'vitest'
import { Logger } from './logger.mjs'

describe('Logger', () => {
  let logger: Logger
  let stdoutOutput = ''
  let stdoutSpy: MockInstance

  beforeAll(() => {
    // set options that differ from defaults
    // for defaults, check Logger class
    Logger.setOptions({
      '--log-level': 'FATAL',
      '--log-colorful': 'true',
      '--log-stack': 'true',
      '--log-stringify': 'true',
    })
    logger = new Logger('logger unit test')
    stdoutSpy = vi.spyOn(process.stdout, 'write').mockImplementation((val) => {
      stdoutOutput = val as string
      return true
    })
  })

  it('applies --log-level', () => {
    // --log-level=FATAL - only .fatal() should write to stdout
    logger.trace('noshow')
    logger.debug('noshow')
    logger.info('noshow')
    logger.warn('noshow')
    logger.error('noshow')
    logger.fatal('show')
    expect(stdoutSpy).toHaveBeenCalledTimes(1)
  })

  it('Applies --log-colorful', () => {
    // --log-colorful - check presence of ansi-styles
    expect(stdoutOutput.includes(ansiStyles.color.blue.open)).toBeTruthy()
  })

  it('Applies --log-stack', () => {
    // --log-stack - expect stack format '(<caller> <file>:<line>:<char>)'
    expect(stdoutOutput.match(/\([^\s]+ .+:\d+:\d+\)/)).toBeTruthy()
  })

  it('Applies --log-stringify', () => {
    // --log-stringify - expect message to be stringified json
    expect(stdoutOutput.includes(JSON.stringify(['show']))).toBeTruthy()
  })
})
