import { FieldDefinitionRow, SubmissionScore } from '@common/interfaces'
import { afterEach, beforeAll, beforeEach, describe, expect, MockInstance, test, vi } from 'vitest'
import { loadConfig } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AggregatorService } from './aggregator-service.mjs'

Logger.setOptions({ '--log-level': 'OFF' })

type AggFunc = keyof Pick<
  AggregatorService,
  'aggSum' | 'aggNaNSum' | 'aggMean' | 'aggNaNMean' | 'aggMedian' | 'aggNaNMedian'
>

interface AggFuncTestCase {
  func: AggFunc
  values: (number | null)[]
  result: number | null
}

const aggFuncs: AggFunc[] = ['aggSum', 'aggNaNSum', 'aggMean', 'aggNaNMean', 'aggMedian', 'aggNaNMedian']

const dummyBoard: { items: SubmissionScore[] } = {
  items: [
    {
      submission_id: 'fcf1dcd0-eddb-4485-a415-66b680b136be',
      test_scorings: [],
      scorings: [
        // field_ids are not relevant for testing, but required in type
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'all_asc', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_asc', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_null', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'negative', score: -800 },
      ],
    },
    {
      submission_id: '5b711a38-1e16-4883-be2d-cd5902b9c8ee',
      test_scorings: [],
      scorings: [
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'all_asc', score: 0.9 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_asc', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'negative', score: -900 },
      ],
    },
    {
      submission_id: 'fce5162c-8288-40c5-b72b-cc7252afb28c',
      test_scorings: [],
      scorings: [
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'all_asc', score: 0.7 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_asc', score: 0.7 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_null', score: 0.7 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'negative', score: -700 },
      ],
    },
  ],
}

describe('Aggregator Service', () => {
  beforeAll(() => {
    const config = loadConfig()

    // Database connectivity not required in unit tests - set to unreachable
    // target to prevent accidental access and to test error behavior.
    config.postgres.host = 'nix.com'
    config.postgres.port = 1 // do not use 0 - would fall back to default

    AggregatorService.create(config)
  })

  test('is instantiated despite faulty config', () => {
    const aggregator = AggregatorService.getInstance()
    expect(aggregator).toBeTruthy()
  })

  describe('yields correct aggregation results', () => {
    test.each([
      // not putting numbers in order, to show that median actually does a thing
      { func: 'aggSum', values: [], result: null },
      { func: 'aggSum', values: [2, 1, null], result: null },
      { func: 'aggSum', values: [2, 1, 3], result: 6 },
      { func: 'aggNaNSum', values: [], result: null },
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
    ] satisfies AggFuncTestCase[])('returns $result from $values with $func', (testCase) => {
      const aggregator = AggregatorService.getInstance()
      const result = aggregator[testCase.func](testCase.values)
      expect(result).toBe(testCase.result)
    })
  })

  describe('calls defined aggregator function or null', async () => {
    const mocks: Record<string, MockInstance> = {}

    beforeEach(() => {
      for (const aggFunc of aggFuncs) {
        mocks[aggFunc] = vi.spyOn(AggregatorService.prototype, aggFunc)
      }
    })

    afterEach(() => {
      for (const aggFunc of aggFuncs) {
        mocks[aggFunc].mockReset()
      }
    })

    test.each([
      { agg_func: 'SUM', func: 'aggSum' },
      { agg_func: 'NANSUM', func: 'aggNaNSum' },
      { agg_func: 'MEAN', func: 'aggMean' },
      { agg_func: 'NANMEAN', func: 'aggNaNMean' },
      { agg_func: 'MEDIAN', func: 'aggMedian' },
      { agg_func: 'NANMEDIAN', func: 'aggNaNMedian' },
      { agg_func: 'TYPO', func: null },
    ] satisfies { agg_func: string; func: AggFunc | null }[])('calls $func for $agg_func', (testCase) => {
      const aggregator = AggregatorService.getInstance()
      aggregator.runAggregationFunction([], testCase.agg_func)
      if (testCase.func) {
        expect(mocks[testCase.func]).toBeCalledTimes(1)
      }
    })
  })

  describe('looks up defined in field', () => {
    test.each([
      {
        agg_fields: null,
        index: undefined,
        returns: 'primary',
      },
      {
        agg_fields: 'primary_from_test',
        index: undefined,
        returns: 'primary_from_test',
      },
      {
        agg_fields: ['primary', 'secondary'],
        index: 0,
        returns: 'primary',
      },
      {
        agg_fields: ['primary', 'secondary'],
        index: 1,
        returns: 'secondary',
      },
      {
        agg_fields: ['primary', 'secondary'],
        index: 2,
        returns: undefined,
      },
    ] satisfies (Pick<FieldDefinitionRow, 'agg_fields'> | { index: number | undefined; returns: string })[])(
      'returns $returns for agg_fields = $agg_fields with index = $index',
      (testCase) => {
        const dummyFieldDefinition: FieldDefinitionRow = {
          id: '41f16002-d807-4722-90a6-d191e6e54adf',
          key: 'primary',
          description: '',
        }
        dummyFieldDefinition.agg_fields = testCase.agg_fields
        const aggregator = AggregatorService.getInstance()
        const fieldName = aggregator.getInFieldName(dummyFieldDefinition, testCase.index ?? 0)
        expect(fieldName).toBe(testCase.returns)
      },
    )
  })

  describe('correctly tracks rank and highest/lowest score for all items', () => {
    let board: typeof dummyBoard

    beforeEach(() => {
      board = structuredClone(dummyBoard)
      const aggregator = AggregatorService.getInstance()
      aggregator.rankBoard(board)
    })

    test.each([
      // in positive scoring cases, lowest score is bound to 0
      { case: 'all ascending', field: 'all_asc', ranks: [2, 1, 3], highest: 0.9, lowest: 0 },
      { case: 'some ascending', field: 'some_asc', ranks: [1, 1, 3], highest: 0.8, lowest: 0 },
      { case: 'some missing', field: 'some_null', ranks: [1, 3, 2], highest: 0.8, lowest: 0 },
      // in highest scoring cases, highest score is bound to 0
      { case: 'negative scores', field: 'negative', ranks: [2, 3, 1], highest: 0, lowest: -900 },
    ])('in case $case', (testCase) => {
      board.items.forEach((submissionScore, index) => {
        const scoring = submissionScore.scorings.find((s) => s.field_key === testCase.field)
        if (scoring) {
          expect(scoring.rank).toBe(testCase.ranks[index])
          expect(scoring.highest).toBe(testCase.highest)
          expect(scoring.lowest).toBe(testCase.lowest)
        }
      })
    })
  })
})
