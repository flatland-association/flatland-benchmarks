import ansiStyles from 'ansi-styles'
import { beforeAll, beforeEach, describe, expect, test, vi } from 'vitest'
import { Logger } from './logger.mjs'

describe('Logger', () => {
  let stdoutOutput = ''

  beforeAll(() => {
    // suppress actual output, store in memory instead
    vi.spyOn(process.stdout, 'write').mockImplementation((val) => {
      stdoutOutput += val as string
      return true
    })
  })

  beforeEach(() => {
    stdoutOutput = ''
  })

  // for defaults, see Logger class
  test.each([
    // --log-level - check only messages of configured level were output
    {
      title: 'should apply default level',
      options: {},
      expects: {
        match: /INFO/, // info must be output
        noMatch: /DEBUG/, // debug must not be output
      },
    },
    {
      title: 'should apply configured --log-level',
      options: { '--log-level': 'FATAL' },
      expects: {
        match: /FATAL/, // must be output
        noMatch: /ERROR/, // must not be output
      },
    },
    // --log-colorful - check presence of ansi-styles
    // (if colored, a "color blue" ansi escape sequence will be present)
    {
      title: 'should apply default coloring',
      options: {},
      expects: {
        noMatch: RegExp(escape(`${ansiStyles.color.blue.open}`)),
      },
    },
    {
      title: 'should apply configured --log-colorful',
      options: { '--log-colorful': 'true' },
      expects: {
        match: RegExp(escape(`${ansiStyles.color.blue.open}`)),
      },
    },
    // --log-stack - expect stack format '(<caller> <file>:<line>:<char>)'
    {
      title: 'should apply default stack option',
      options: {},
      expects: {
        noMatch: /\([^\s]+ .+:\d+:\d+\)/,
      },
    },
    {
      title: 'should apply configured --log-stack option',
      options: { '--log-stack': 'true' },
      expects: {
        match: /\([^\s]+ .+:\d+:\d+\)/,
      },
    },
    // --log-stringify - expect message to be stringified json
    {
      title: 'should apply default stringify option',
      options: {},
      expects: {
        noMatch: /\["info",\[1\]\]/,
      },
    },
    {
      title: 'should apply configured --log-stringify option',
      options: { '--log-stringify': 'true' },
      expects: {
        match: /\["info",\[1\]\]/,
      },
    },
  ])('$title', ({ options, expects }) => {
    Logger.setOptions(options)
    const logger = new Logger('logger-unit-test')
    // pass a primitive and a non-primitive for the stringification test
    // (it's passed always, but only checked in the stringify cases)
    logger.trace('trace', [1])
    logger.debug('debug', [1])
    logger.info('info', [1])
    logger.warn('warn', [1])
    logger.error('error', [1])
    logger.fatal('fatal', [1])
    if (expects?.match) {
      expect(stdoutOutput).toMatch(expects.match)
    }
    if (expects?.noMatch) {
      expect(stdoutOutput).not.toMatch(expects.noMatch)
    }
  })
})

// escapes the square bracket for use in RegExp
function escape(string: string) {
  return string.replace('[', '\\[')
}
