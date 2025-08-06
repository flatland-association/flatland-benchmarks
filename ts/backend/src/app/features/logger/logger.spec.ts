import ansiStyles from 'ansi-styles'
import { afterAll, beforeAll, beforeEach, describe, expect, MockInstance, test, vi } from 'vitest'
import { cliOptions } from '../config/command-line.mjs'
import { Logger } from './logger.mjs'

interface TestCase {
  title: string
  options: cliOptions
  messages: unknown[]
  expects: {
    match?: RegExp
    noMatch?: RegExp
  }
}

const dummyPrimitives = [
  false,
  2,
  'test-string',
  null,
  undefined,
  { test: true },
  [3, 4],
  Symbol('test-symbol'),
  BigInt(999),
  () => {
    console.log('test-console-log')
  },
]

describe('Logger', () => {
  let stdoutMock: MockInstance
  let stdoutOutput = ''

  beforeAll(() => {
    // suppress actual output, store in memory instead
    stdoutMock = vi.spyOn(process.stdout, 'write').mockImplementation((val) => {
      stdoutOutput += val as string
      return true
    })
  })

  afterAll(() => {
    stdoutMock.mockReset()
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
      messages: ['logged-message'],
      expects: {
        match: /INFO/, // info must be output
        noMatch: /DEBUG/, // debug must not be output
      },
    },
    {
      title: 'should apply configured --log-level',
      options: { '--log-level': 'FATAL' },
      messages: ['logged-message'],
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
      messages: ['logged-message'],
      expects: {
        noMatch: RegExp(escape(`${ansiStyles.color.blue.open}`)),
      },
    },
    {
      title: 'should apply configured --log-colorful',
      options: { '--log-colorful': 'true' },
      messages: ['logged-message'],
      expects: {
        match: RegExp(escape(`${ansiStyles.color.blue.open}`)),
      },
    },
    // --log-stack - expect stack format '(<caller> <file>:<line>:<char>)'
    {
      title: 'should apply default stack option',
      options: {},
      messages: ['logged-message'],
      expects: {
        noMatch: /\([^\s]+ .+:\d+:\d+\)/,
      },
    },
    {
      title: 'should apply configured --log-stack option',
      options: { '--log-stack': 'true' },
      messages: ['logged-message'],
      expects: {
        match: /\([^\s]+ .+:\d+:\d+\)/,
      },
    },
    // --log-stringify - expect message to be stringified json
    {
      title: 'should apply default stringify option',
      options: {},
      // pass a primitive and a non-primitive for the stringification test
      messages: ['logged-message', { test: true }],
      expects: {
        // string single quoted, object properties unquoted
        match: /'logged-message'.*\{ test:/,
      },
    },
    {
      title: 'should apply configured --log-stringify option',
      options: { '--log-stringify': 'true' },
      // pass a primitive and a non-primitive for the stringification test
      messages: ['logged-message', { test: true }],
      expects: {
        // string double quoted, object properties quoted
        match: /"logged-message".*"test"/,
      },
    },
    // preserve all data types
    {
      title: 'should preserve meaningful info for all data types',
      options: { '--log-stringify': 'false' },
      messages: dummyPrimitives,
      expects: {
        match:
          /false,\s*2,\s*'test-string',\s*null,\s*undefined,\s*{ test: true },\s*\[ 3, 4 \],\s*Symbol\(test-symbol\),\s*999n,\s*.*test-console-log/,
      },
    },
    {
      title: 'should preserve meaningful info for all data types with --log-stringify option',
      options: { '--log-stringify': 'true' },
      messages: dummyPrimitives,
      expects: {
        match:
          /false,2,"test-string",null,"null\(undefined\)",{"test":true},\[3,4\],"Symbol\(test-symbol\)","BigInt\(999\)",.*test-console-log/,
      },
    },
    // preserve messages of type Error
    {
      title: 'should preserve Error',
      options: { '--log-stringify': 'false' },
      messages: [new Error('test-error')],
      expects: {
        match: /Error: test-error/,
      },
    },
    {
      title: 'should preserve Error with --log-stringify option',
      options: { '--log-stringify': 'true' },
      messages: [new Error('test-error')],
      expects: {
        match: /"Error: test-error/,
      },
    },
  ] satisfies TestCase[])('$title', (testCase: TestCase) => {
    Logger.setOptions(testCase.options)
    const logger = new Logger('logger-unit-test')

    // (it's passed always, but only checked in the stringify cases)
    logger.trace(...testCase.messages)
    logger.debug(...testCase.messages)
    logger.info(...testCase.messages)
    logger.warn(...testCase.messages)
    logger.error(...testCase.messages)
    logger.fatal(...testCase.messages)
    if (testCase.expects?.match) {
      expect(stdoutOutput).toMatch(testCase.expects.match)
    }
    if (testCase.expects?.noMatch) {
      expect(stdoutOutput).not.toMatch(testCase.expects.noMatch)
    }
  })
})

// escapes the square bracket for use in RegExp
function escape(string: string) {
  return string.replace('[', '\\[')
}
