import { GroupLeaderboard } from '@common/interfaces'
import { ResultsController } from '../../src/app/features/controller/results.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment, testUserJwt } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('Results controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(ResultsController, testConfig)
  })

  describe('should return aggregated campaign leaderboard', () => {
    let leaderboard: GroupLeaderboard | undefined

    beforeAll(async () => {
      const res = await controller.testGet(
        '/results/campaigns/:group_id',
        {
          params: { group_id: '0ca46887-897a-463f-bf83-c6cd6269a976' },
        },
        testUserJwt,
      )
      expect(res.status).toBe(200)
      expect(res.body).toBeApiResponse()
      leaderboard = res.body.body?.at(0)
      expect(leaderboard).toBeTruthy()
    })

    // group might contain additional benchmarks - for test, check that
    // "effectiveness" and "resilience" are present and are scored correctly
    test.each([
      // comparing by something else than uuid would require additional calls
      { uuid: 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', score: 0.71 },
      { uuid: '1df5f920-ed2c-4873-957b-723b4b5d81b1', score: 0.82 },
    ])('should score $uuid with $score', (testCase) => {
      const benchmark = leaderboard?.items.find(
        // comparing by something else than uuid would require additional calls
        (item) => item.benchmark_id === testCase.uuid,
      )
      expect(benchmark).toBeTruthy()
      expect(benchmark?.scorings['primary']?.score).toBeCloseTo(testCase.score, 2)
    })
  })
})
