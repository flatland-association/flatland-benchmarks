import { MockInstance } from 'vitest'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import { AggregatorService } from '../../src/app/features/services/aggregator-service.mjs'
import { SqlService } from '../../src/app/features/services/sql-service.mjs'
import { getTestConfig } from './setup.mjs'

Logger.setOptions({ '--log-level': 'NONE' })

type AggregatorPublicMethods = keyof Pick<
  AggregatorService,
  | 'getSubmissionScenarioScore'
  | 'getSubmissionTestScore'
  | 'getSubmissionScore'
  | 'getBenchmarkTestLeaderboard'
  | 'getBenchmarkLeaderboard'
  | 'getCampaignItemOverview'
  | 'getCampaignOverview'
>

interface AggregatorPublicMethodTestCase<M extends AggregatorPublicMethods> {
  method: M
  args: Parameters<AggregatorService[M]>
  returns: Awaited<ReturnType<AggregatorService[M]>>
}

const dummySubmissionId = '00927bb7-d5ec-4949-9265-6134efa246f7'
const dummyScenarioId = '0add02a3-fa2a-44f2-8d28-5671074d73a7'
const dummyTestId = '67717de0-0d2b-4f51-81a3-5f6f038941b7'
const dummyBenchmarkId = '12350c74-2dda-4ded-9ffe-fb20e188264a'
const dummyGroupId = 'cebb08fa-ff09-4eab-ac3e-b2f84db7c46b'

describe.sequential('Aggregator Service (with Postgres)', async () => {
  describe('offline', async () => {
    let loggerWarnMock: MockInstance
    let loggerErrorMock: MockInstance

    beforeAll(async () => {
      const testConfig = await getTestConfig()
      testConfig.postgres.host = 'nix.com'
      testConfig.postgres.port = 1 // do not use 0 - would fall back to default
      SqlService.create(testConfig)
      AggregatorService.create(testConfig)
    })

    beforeEach(() => {
      loggerWarnMock = vi.spyOn(Logger.prototype, 'warn')
      loggerErrorMock = vi.spyOn(Logger.prototype, 'error')
    })

    afterEach(() => {
      loggerWarnMock.mockReset()
      loggerErrorMock.mockReset()
    })

    test.each([
      {
        method: 'getSubmissionScenarioScore',
        args: [dummySubmissionId, [dummyScenarioId]],
        returns: [
          {
            scenario_id: dummyScenarioId,
            scorings: [],
          },
        ],
      } satisfies AggregatorPublicMethodTestCase<'getSubmissionScenarioScore'>,
      {
        method: 'getSubmissionTestScore',
        args: [dummySubmissionId, [dummyTestId]],
        returns: [
          {
            test_id: dummyTestId,
            scenario_scorings: [],
            scorings: [],
          },
        ],
      } satisfies AggregatorPublicMethodTestCase<'getSubmissionTestScore'>,
      {
        method: 'getSubmissionScore',
        args: [[dummySubmissionId]],
        returns: [
          {
            submission_id: dummySubmissionId,
            test_scorings: [],
            scorings: [],
          },
        ],
      } satisfies AggregatorPublicMethodTestCase<'getSubmissionScore'>,
      {
        method: 'getBenchmarkTestLeaderboard',
        args: [dummyBenchmarkId, [dummyTestId]],
        returns: [
          {
            benchmark_id: dummyBenchmarkId,
            items: [],
          },
        ],
      } satisfies AggregatorPublicMethodTestCase<'getBenchmarkTestLeaderboard'>,
      {
        method: 'getBenchmarkLeaderboard',
        args: [[dummyBenchmarkId]],
        returns: [{ benchmark_id: dummyBenchmarkId, items: [] }],
      } satisfies AggregatorPublicMethodTestCase<'getBenchmarkLeaderboard'>,
      {
        method: 'getCampaignItemOverview',
        args: [[dummyBenchmarkId]],
        returns: [{ benchmark_id: dummyBenchmarkId, items: [], scorings: [] }],
      } satisfies AggregatorPublicMethodTestCase<'getCampaignItemOverview'>,
      {
        method: 'getCampaignOverview',
        args: [[dummyGroupId]],
        returns: [
          {
            suite_id: dummyGroupId,
            items: [],
          },
        ],
      } satisfies AggregatorPublicMethodTestCase<'getCampaignOverview'>,
    ])('should throw when calling $method', async (testCase) => {
      const aggregator = AggregatorService.getInstance()
      //@ts-expect-error spread
      await expect(aggregator[testCase.method](...testCase.args)).rejects.toThrow()
    })
  })
})
