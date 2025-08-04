import { beforeAll, describe, expect, test } from 'vitest'
import { loadConfig } from '../config/config.mjs'
import { AggregatorService } from './aggregator-service.mjs'

type AggFuncs = keyof Pick<
  AggregatorService,
  'aggSum' | 'aggNaNSum' | 'aggMean' | 'aggNaNMean' | 'aggMedian' | 'aggNaNMedian'
>

interface AggFuncTestCase {
  func: AggFuncs
  values: (number | null)[]
  result: number | null
}

describe('Aggregator Service', () => {
  beforeAll(() => {
    const config = loadConfig()

    // Database connectivity not required in unit tests - set to unreachable
    // target to prevent accidental access and to test error behavior.
    config.postgres.host = 'nix.com'
    config.postgres.port = 1 // do not use 0 - would fall back to default

    // SqlService.create(config)
    AggregatorService.create(config)
  })

  test('is instantiated despite faulty config', () => {
    const aggregator = AggregatorService.getInstance()
    expect(aggregator).toBeTruthy()
  })

  test.each([
    // not putting numbers in order, to show that median actually does a thing
    { func: 'aggSum', values: [], result: 0 },
    { func: 'aggSum', values: [2, 1, null], result: null },
    { func: 'aggSum', values: [2, 1, 3], result: 6 },
    { func: 'aggNaNSum', values: [], result: 0 },
    { func: 'aggNaNSum', values: [2, 1, null], result: 3 },
    { func: 'aggNaNSum', values: [2, 1, 3], result: 6 },
    { func: 'aggMean', values: [], result: null },
    { func: 'aggMean', values: [2, 1, null], result: null },
    { func: 'aggMean', values: [2, 1, 3], result: 2 },
    { func: 'aggNaNMean', values: [], result: null },
    { func: 'aggNaNMean', values: [2, 1, null], result: 1.5 },
    { func: 'aggNaNMean', values: [2, 1, 3], result: 2 },
    { func: 'aggMedian', values: [], result: null },
    { func: 'aggMedian', values: [2, 1, null], result: null },
    { func: 'aggMedian', values: [2, 1, 3], result: 2 },
    { func: 'aggNaNMedian', values: [], result: null },
    { func: 'aggNaNMedian', values: [2, 1, null], result: 1.5 },
    { func: 'aggNaNMedian', values: [2, 1, 3], result: 2 },
  ] satisfies AggFuncTestCase[])('should calculate $result from $values with $func', (testCase) => {
    const aggregator = AggregatorService.getInstance()
    const result = aggregator[testCase.func](testCase.values)
    expect(result).toBe(testCase.result)
  })
})
