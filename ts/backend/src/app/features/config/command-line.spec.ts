import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, MockInstance, test, vi } from 'vitest'
import { Logger } from '../logger/logger.mjs'
import { commandLineArgs, flagEvaluator, parseCommandLine } from './command-line.mjs'

describe('Command Line', () => {
  let stdoutOutput = ''
  let evaluatorCalls = 0

  let consoleMock: MockInstance
  let loggerWarnMock: MockInstance
  let loggerErrorMock: MockInstance

  beforeAll(() => {
    // replace with testable options
    commandLineArgs.splice(
      0,
      commandLineArgs.length,
      commandLineArgs.find((a) => a.argument == '--help')!,
      {
        argument: '--test-value' as '--help',
        alias: '-t',
        description: 'value test',
        type: 'string',
        default: 'blank',
      },
      {
        argument: '--test-flag' as '--help',
        description: 'flag test',
        evaluator: flagEvaluator,
      },
      {
        argument: '--test-evaluator' as '--help',
        alias: '-e',
        description: 'evaluator / de-duplication test',
        evaluator: (val?: string) => {
          evaluatorCalls++
          return val
        },
      },
    )
    // suppress actual output, store in memory instead
    consoleMock = vi.spyOn(console, 'log').mockImplementation((val: string) => {
      stdoutOutput += val as string
      return true
    })
  })

  afterAll(() => {
    consoleMock.mockReset()
  })

  beforeEach(() => {
    stdoutOutput = ''
    evaluatorCalls = 0
    loggerWarnMock = vi.spyOn(Logger.prototype, 'warn')
    loggerErrorMock = vi.spyOn(Logger.prototype, 'error')
  })

  afterEach(() => {
    loggerWarnMock.mockReset()
    loggerErrorMock.mockReset()
    vi.unstubAllGlobals()
  })

  test.each([
    {
      should: 'should accept zero arguments',
      args: [],
      options: {},
    },
    {
      should: 'should pretty print help',
      args: ['--help'],
      options: {
        '--help': undefined,
      },
      outputs: 'Print this message',
    },
    {
      should: 'should allow aliases',
      args: ['-h'],
      options: {
        '--help': undefined,
      },
      outputs: 'Print this message',
    },
    {
      should: 'should set argument value',
      args: ['--test-value=TEST'],
      options: {
        '--test-value': 'TEST',
      },
    },
    {
      should: 'should turn on flag',
      args: ['--test-flag'],
      options: {
        '--test-flag': 'true',
      },
    },
    {
      should: 'should turn off flag',
      args: ['--test-flag=false'],
      options: {
        '--test-flag': 'false',
      },
    },
    {
      should: 'should warn on duplicates and de-duplicate before evaluating',
      args: ['--test-evaluator=1', '--test-evaluator=2', '-e=3'],
      options: {
        '--test-evaluator': '1',
      },
      evaluatorCalls: 1,
      warnCalls: 2,
    },
    {
      should: 'should error on invalid args',
      args: ['--test-invalid'],
      options: {},
      errorCalls: 1,
    },
  ])('$should', (testCase) => {
    // apply test args and parse them
    stubArgv(testCase.args)
    const cliOptions = parseCommandLine()
    // assert test expectations
    expect(cliOptions).toStrictEqual(testCase.options)
    if (testCase.outputs) {
      expect(stdoutOutput).toMatch(testCase.outputs)
    }
    if (typeof testCase.evaluatorCalls === 'number') {
      expect(evaluatorCalls).toBe(testCase.evaluatorCalls)
    }
    if (typeof testCase.warnCalls === 'number') {
      expect(loggerWarnMock).toBeCalledTimes(testCase.warnCalls)
    }
    if (typeof testCase.errorCalls === 'number') {
      expect(loggerErrorMock).toBeCalledTimes(testCase.errorCalls)
    }
  })
})

function stubArgv(extraArgs: string[] = []) {
  vi.stubGlobal('process', {
    argv: [process.argv[0], process.argv[1], ...extraArgs],
  })
}
