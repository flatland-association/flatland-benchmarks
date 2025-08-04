import { CampaignItemOverview, CampaignOverview, Leaderboard } from '@common/interfaces'
import { ResultsController } from '../../src/app/features/controller/results.controller.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment, testUserJwt } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

Logger.setOptions({ '--log-level': 'ERROR' })

describe.sequential('Results controller', () => {
  let controller: ControllerTestAdapter

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(ResultsController, testConfig)
  })

  test('should return submission total score', async () => {
    const res = await controller.testGet(
      '/results/submissions/:submission_ids',
      { params: { submission_ids: 'cd4d44bc-d40e-4173-bccb-f04e0be1b2ae' } },
      testUserJwt,
    )
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    // TOFIX: 0.0946 is "submission score" mistakenly multiplied with weighing
    // for benchmark score. See issue:
    // https://github.com/flatland-association/flatland-benchmarks/issues/320
    expect(res.body.body?.at(0)?.scorings['primary']?.score).toBeCloseTo(0.0946, 4)
  })

  test('should return submission test score', async () => {
    const res = await controller.testGet(
      '/results/submissions/:submission_id/tests/:test_ids',
      {
        params: {
          submission_id: 'cd4d44bc-d40e-4173-bccb-f04e0be1b2ae',
          test_ids: 'aeabd5b9-4e86-4c7a-859f-a32ff1be5516',
        },
      },
      testUserJwt,
    )
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    // TOFIX: body should be array, see
    // https://github.com/flatland-association/flatland-benchmarks/issues/352
    expect(res.body.body?.scorings['primary']?.score).toBeCloseTo(0.86)
  })

  test('should return submission scenario score', async () => {
    const res = await controller.testGet(
      '/results/submissions/:submission_id/scenario/:scenario_ids',
      {
        params: {
          submission_id: 'ca001ce9-f10f-4dea-a299-2a0efce0f00d',
          scenario_ids: '94547c7d-80ec-47ac-9146-80da362b79fa',
        },
      },
      testUserJwt,
    )
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body).toHaveLength(1)
    expect(res.body.body?.at(0)?.scorings['primary']?.score).toBeCloseTo(0.45, 2)
  })

  // Benchmark leaderboard does not make valid sense with campaign test data,
  // but for testing purposes (checking if the aggregator returns consistent
  // values), probing this leaderboard is good enough.
  describe('should return benchmark leaderboard', async () => {
    let board: Leaderboard | undefined

    beforeAll(async () => {
      const res = await controller.testGet(
        '/results/benchmarks/:benchmark_ids',
        {
          params: {
            benchmark_ids: 'c5145011-ce69-4679-8694-e1dbeb1ee4bb',
          },
        },
        testUserJwt,
      )
      expect(res.status).toBe(200)
      expect(res.body).toBeApiResponse()
      board = res.body.body?.at(0)
      // benchmark leaderboard contains more than one per test
      expect(board?.items).toHaveLength(9)
    })

    // leaderboard is sorted by submission score (which is mistakenly weighed)
    // https://github.com/flatland-association/flatland-benchmarks/issues/320
    test.each([
      { rank: 1, submission_id: 'd3408a40-c7b5-4d34-9f89-fd0322114273', score: 0.1012 },
      { rank: 2, submission_id: '0f4ecf0f-c0a8-4141-9b28-1cb488808e14', score: 0.099 },
      { rank: 3, submission_id: 'cd4d44bc-d40e-4173-bccb-f04e0be1b2ae', score: 0.0946 },
      { rank: 4, submission_id: 'fb655288-2b79-4a1f-a9a7-bf449ffa3f70', score: 0.0891 },
      { rank: 5, submission_id: 'c0781558-f35a-4f06-8bf4-6cff18b165e0', score: 0.0792 },
      { rank: 6, submission_id: '392b0c0a-5ea0-45c9-86c7-50d16c35271b', score: 0.0693 },
      { rank: 7, submission_id: '398684ee-fb13-4a73-95ac-f5a6584bb9ea', score: 0.0583 },
      { rank: 8, submission_id: 'ca001ce9-f10f-4dea-a299-2a0efce0f00d', score: 0.0495 },
      { rank: 9, submission_id: '5fa91da5-127b-408c-8863-a3ac670030b3', score: 0.022 },
    ])('having $submission_id on rank $rank with score $score', (testCase) => {
      // rank must match index (off by one)
      const submission = board?.items[testCase.rank - 1]
      expect(submission?.submission_id).toBe(testCase.submission_id)
      expect(submission?.scorings['primary']?.score).toBeCloseTo(testCase.score, 4)
      expect(submission?.scorings['primary']?.rank).toBe(testCase.rank)
    })
  })

  describe('should return test leaderboard', async () => {
    let board: Leaderboard | undefined

    beforeAll(async () => {
      const res = await controller.testGet(
        '/results/benchmarks/:benchmark_id/tests/:test_ids',
        {
          params: {
            benchmark_id: 'c5145011-ce69-4679-8694-e1dbeb1ee4bb',
            test_ids: 'aeabd5b9-4e86-4c7a-859f-a32ff1be5516',
          },
        },
        testUserJwt,
      )
      expect(res.status).toBe(200)
      expect(res.body).toBeApiResponse()
      board = res.body.body?.at(0)
      expect(board?.items).toHaveLength(2)
    })

    // leaderboard is sorted by submission score (which is mistakenly weighed,
    // but since the weighs are almost equal, weighing does not have any effect
    // on order)
    test.each([
      { rank: 1, submission_id: 'cd4d44bc-d40e-4173-bccb-f04e0be1b2ae', score: 0.86 },
      { rank: 2, submission_id: '5fa91da5-127b-408c-8863-a3ac670030b3', score: 0.2 },
    ])('having $submission_id on rank $rank', (testCase) => {
      // rank must match index (off by one)
      const submission = board?.items[testCase.rank - 1]
      expect(submission?.submission_id).toBe(testCase.submission_id)
      // only requested test should be present
      expect(submission?.test_scorings).toHaveLength(1)
      expect(submission?.test_scorings.at(0)?.test_id).toBe('aeabd5b9-4e86-4c7a-859f-a32ff1be5516')
      expect(submission?.test_scorings.at(0)?.scorings['primary']?.score).toBeCloseTo(testCase.score, 2)
      expect(submission?.test_scorings.at(0)?.scorings['primary']?.rank).toBe(testCase.rank)
    })
  })

  describe('should return campaign item board', async () => {
    let board: CampaignItemOverview | undefined

    beforeAll(async () => {
      const res = await controller.testGet(
        '/results/campaign-items/:benchmark_ids',
        {
          params: {
            benchmark_ids: 'c5145011-ce69-4679-8694-e1dbeb1ee4bb',
          },
        },
        testUserJwt,
      )
      expect(res.status).toBe(200)
      expect(res.body).toBeApiResponse()
      board = res.body.body?.at(0)
      expect(board?.items).toHaveLength(8)
    })

    // leaderboard is sorted by test
    test.each([
      { index: 0, test_id: 'aeabd5b9-4e86-4c7a-859f-a32ff1be5516', score: 0.86 },
      { index: 1, test_id: '42fbb160-a300-43f7-9268-e290f6daad9c', score: 0.45 },
      { index: 2, test_id: 'a40240d3-580e-4bad-a90d-608743600422', score: 0.9 },
      { index: 3, test_id: 'cba954e0-a48b-473a-bf9d-d12a1b5e946f', score: 0.92 },
      { index: 4, test_id: '7f5bf3a1-ac9e-443f-8607-eaa51d80c85e', score: 0.63 },
      { index: 5, test_id: '4f0ea3a1-71df-4528-ac0e-b3df1488e970', score: 0.72 },
      { index: 6, test_id: '687a01f3-4dc5-4926-a862-7f307c3df597', score: 0.53 },
      { index: 7, test_id: '836bfb70-1366-4e27-aca5-2bd0aeaeb366', score: 0.81 },
    ])('having $score for kpi $test_id', (testCase) => {
      const kpi = board?.items[testCase.index]
      expect(kpi?.test_id).toBe(testCase.test_id)
      expect(kpi?.scorings!['primary']?.score).toBeCloseTo(testCase.score, 2)
      // per definition, items only ever contain top submission
      expect(kpi?.scorings!['primary']?.rank).toBe(1)
    })
  })

  test('should return empty campaign item board where no submissions were made', async () => {
    const res = await controller.testGet(
      '/results/campaign-items/:benchmark_ids',
      {
        params: {
          benchmark_ids: '74b5d783-54cd-4161-a974-8865118dc2f7',
        },
      },
      testUserJwt,
    )
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    // five tests for benchmark defined,
    expect(res.body.body?.at(0)?.items).toHaveLength(5)
    //... all of them having no submission (and therefore no score)
    expect(res.body.body?.at(0)?.items.every((scoring) => scoring.scorings === null)).toBeTruthy()
  })

  describe('should return aggregated campaign leaderboard', () => {
    let overview: CampaignOverview | undefined

    beforeAll(async () => {
      const res = await controller.testGet(
        '/results/campaigns/:group_ids',
        {
          params: { group_ids: '0ca46887-897a-463f-bf83-c6cd6269a976' },
        },
        testUserJwt,
      )
      expect(res.status).toBe(200)
      expect(res.body).toBeApiResponse()
      overview = res.body.body?.at(0)
      expect(overview).toBeTruthy()
    })

    // group might contain additional benchmarks - for test, check that
    // "effectiveness" and "resilience" are present and are scored correctly
    test.each([
      // comparing by something else than uuid would require additional calls
      { uuid: 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', score: 0.71 },
      { uuid: '1df5f920-ed2c-4873-957b-723b4b5d81b1', score: 0.82 },
    ])('should score $uuid with $score', (testCase) => {
      const benchmark = overview?.items.find(
        // comparing by something else than uuid would require additional calls
        (item) => item.benchmark_id === testCase.uuid,
      )
      expect(benchmark).toBeTruthy()
      expect(benchmark?.scorings['primary']?.score).toBeCloseTo(testCase.score, 2)
    })
  })
})
