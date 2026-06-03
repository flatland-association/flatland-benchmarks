import { SubmissionRow } from '@common/interfaces'
import { StripId } from '@common/utility-types'
import { StatusCodes } from 'http-status-codes'
import { MockInstance } from 'vitest'
import { SubmissionController } from '../../src/app/features/controller/submission.controller.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import { CeleryService } from '../../src/app/features/services/celery-client-service.mjs'
import { SqlService } from '../../src/app/features/services/sql-service.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
  testAdminJwt,
  testNoRoleJwt,
  testOtherUserJwt,
  testUserJwt,
} from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

Logger.setOptions({ '--log-level': 'OFF' })

const testSubmission: StripId<SubmissionRow> = {
  benchmark_id: '20ccc7c1-034c-4880-8946-bffc3fed1359',
  test_ids: ['557d9a00-7e6d-410b-9bca-a017ca7fe3aa'],
  name: 'test',
  submission_data_url: 'none',
}

const testSubmissionWithTags: StripId<SubmissionRow> = {
  benchmark_id: '20ccc7c1-034c-4880-8946-bffc3fed1359',
  test_ids: ['557d9a00-7e6d-410b-9bca-a017ca7fe3aa'],
  name: 'test',
  submission_data_url: 'none',
  tags: 'ml',
}

const testQueue = 'blabla' // Set in ts\backend\src\migration\data\V8.1__override_queue.sql

describe.sequential('Submission controller', () => {
  let controller: ControllerTestAdapter
  let submissionUuid: string
  let celeryMock: MockInstance

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
    celeryMock = vi.spyOn(CeleryService.prototype, 'sendTask')
  })

  afterAll(() => {
    celeryMock.mockReset()
  })

  test('should reject post submissions from unauthorized users', async () => {
    const res = await controller.testPost('/submissions', { body: testSubmission })
    assertApiResponse(res, 401)
  })

  test('should reject post submission with missing required properties', async () => {
    const faultySubmission = structuredClone(testSubmission)
    faultySubmission.benchmark_id = ''
    const res = await controller.testPost('/submissions', { body: faultySubmission }, testUserJwt)
    assertApiResponse(res, StatusCodes.BAD_REQUEST)
  })

  test('should reject post submission with invalid link (inexistent benchmark)', async () => {
    const faultySubmission = structuredClone(testSubmission)
    // using test_id as benchmark_id
    faultySubmission.benchmark_id = '557d9a00-7e6d-410b-9bca-a017ca7fe3aa'
    const res = await controller.testPost('/submissions', { body: faultySubmission }, testUserJwt)
    assertApiResponse(res, StatusCodes.BAD_REQUEST)
  })

  test('should reject post submission with invalid link (inexistent test)', async () => {
    const faultySubmission = structuredClone(testSubmission)
    // using benchmark_id as test_id
    faultySubmission.test_ids = ['20ccc7c1-034c-4880-8946-bffc3fed1359']
    const res = await controller.testPost('/submissions', { body: faultySubmission }, testUserJwt)
    assertApiResponse(res, StatusCodes.BAD_REQUEST)
  })

  test('should reject post submission with invalid link (test not in benchmark)', async () => {
    const faultySubmission = structuredClone(testSubmission)
    // using test_id from ts\backend\src\migration\data\V4.1__ai4realnet_example.sql
    faultySubmission.test_ids = ['aeabd5b9-4e86-4c7a-859f-a32ff1be5516']
    const res = await controller.testPost('/submissions', { body: faultySubmission }, testUserJwt)
    assertApiResponse(res, StatusCodes.BAD_REQUEST)
  })

  test('should allow post submissions', async () => {
    const res = await controller.testPost('/submissions', { body: testSubmission }, testUserJwt)
    assertApiResponse(res)
    submissionUuid = res.body.body.id
    // Asserting this after setting submissionUuid, otherwise failing this would
    // cause other tests relying on it to fail too:
    expect(celeryMock).toHaveBeenCalledWith(
      testQueue,
      expect.objectContaining({
        submission_data_url: testSubmission.submission_data_url,
        tests: testSubmission.test_ids,
      }),
      expect.anything(),
    )
  })

  test('should allow post submissions with skipping enqueuing message', async () => {
    const celeryMock = vi.spyOn(CeleryService.prototype, 'sendTask')
    const res = await controller.testPost('/submissions/skip_enqueue', { body: testSubmission }, testUserJwt)
    assertApiResponse(res)
    submissionUuid = res.body.body.id
    expect(celeryMock).toHaveBeenCalledTimes(0)
  })

  test('should allow post submissions with tags', async () => {
    const res = await controller.testPost('/submissions', { body: testSubmissionWithTags }, testUserJwt)
    assertApiResponse(res)
    submissionUuid = res.body.body.id
    // Asserting this after setting submissionUuid, otherwise failing this would
    // cause other tests relying on it to fail too:
    expect(celeryMock).toHaveBeenCalledWith(
      testQueue,
      expect.objectContaining({
        submission_data_url: testSubmission.submission_data_url,
        tests: testSubmission.test_ids,
      }),
      expect.anything(),
    )

    const resSubmissions = await controller.testGet(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: res.body.body.id },
      },
      testUserJwt,
    )
    assertApiResponse(resSubmissions)
    expect(resSubmissions.body.body.at(0)?.tags).toBe('ml')
  })
  // data set in
  // - ts\backend\src\migration\data\V4.1__ai4realnet_example.sql
  // - ts\backend\src\migration\data\V5.2__publishable_submission.sql
  test('should list published submissions (no user)', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet('/submissions', {})
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    // Have faith that if one published is contained and one unpublished not
    // contained the controller is sufficiently tested
    expect(submissionIds).toContain('cd4d44bc-d40e-4173-bccb-f04e0be1b2ae')
    expect(submissionIds).not.toContain('06ad18b5-e697-4684-aa7b-76b5c82c4307')
  })

  // data set in
  // - ts/backend/src/migration/data/V4.1__ai4realnet_example.sql
  test('should list submissions for benchmark', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet('/submissions', {
      query: { benchmark_ids: '1df5f920-ed2c-4873-957b-723b4b5d81b1' },
    })
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    expect(submissionIds).toContain('a8bb32be-a596-4636-898d-7e1fe7c7492d')
  })

  // data set in
  // - ts/backend/src/migration/data/V18.7__competition_submissions.sql
  test('should list all submissions for benchmark if admin', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet(
      '/submissions/all',
      {
        query: { benchmark_ids: 'c85d5fc2-15da-4a62-8e14-28d1261c29bd' },
      },
      testAdminJwt,
    )
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    expect(submissionIds).toContain('c912c1fc-faa0-486c-b6f6-7f3411e4f307')
  })

  test('should deny listing all submissions for benchmark if only user', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet(
      '/submissions/all',
      {
        query: { benchmark_ids: 'c85d5fc2-15da-4a62-8e14-28d1261c29bd' },
      },
      testUserJwt,
    )
    assertApiResponse(res, StatusCodes.FORBIDDEN)
  })

  test('should deny listing own submissions (no user)', async () => {
    const res = await controller.testGet('/submissions/own', {})
    assertApiResponse(res, StatusCodes.UNAUTHORIZED)
    expect(res.body.body).toBeUndefined()
  })

  test('should list own submissions (user required)', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet('/submissions/own', {}, testUserJwt)
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    expect(submissionIds).toContain(submissionUuid)
  })

  test('should return published submission (no user)', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet('/submissions/:submission_ids', {
      params: { submission_ids: 'cd4d44bc-d40e-4173-bccb-f04e0be1b2ae' },
    })
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
  })

  test('should deny returning unpublished submission (no user)', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet('/submissions/:submission_ids', { params: { submission_ids: submissionUuid } })
    assertApiResponse(res, StatusCodes.NOT_FOUND)
    expect(res.body.body).toHaveLength(0)
  })

  test('should return unpublished own submission (user required)', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet(
      '/submissions/:submission_ids',
      { params: { submission_ids: submissionUuid } },
      testUserJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
  })

  test('should allow publishing submissions', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPatch(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: submissionUuid },
        body: { published: true },
      },
      testUserJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
    expect(res.body.body.at(0)?.published).toBeTruthy()
  })

  test('should allow patching submission tags', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPatch(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: submissionUuid },
        body: { tags: 'abcd' },
      },
      testUserJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
    expect(res.body.body.at(0)?.tags).toEqual('abcd')
  })

  test('should deny patching submission', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPatch(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: submissionUuid },
        body: { tags: 'abcd' },
      },
      testNoRoleJwt,
    )
    assertApiResponse(res, StatusCodes.FORBIDDEN)
    expect(res.body.body).toBeUndefined()
  })

  test('should allow patching submissions with empty body', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPatch(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: submissionUuid },
        body: {},
      },
      testUserJwt,
    )
    assertApiResponse(res)
  })

  test('should deny patching other user submission tags', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPatch(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: submissionUuid },
        body: { tags: 'abcd' },
      },
      testOtherUserJwt,
    )
    assertApiResponse(res, StatusCodes.FORBIDDEN)
    expect(res.body.body).toBeUndefined()
  })

  test('should allow admin to patch other user submission tags', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPatch(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: submissionUuid },
        body: { tags: 'efg' },
      },
      testAdminJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
    expect(res.body.body.at(0)?.tags).toEqual('efg')
  })

  test('should prevent submissions if daily limit 0', async () => {
    const testConfig = await getTestConfig()
    testConfig.submissions = { global: { dailyLimit: 0 } }
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
    const res = await controller.testPost('/submissions', { body: testSubmission }, testUserJwt)
    assertApiResponse(res, StatusCodes.TOO_MANY_REQUESTS)
  })

  test('should not prevent posting submissions if admin even if daily limit 0', async () => {
    const testConfig = await getTestConfig()
    testConfig.submissions = { global: { dailyLimit: 0 } }
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
    const res = await controller.testPost('/submissions', { body: testSubmission }, testAdminJwt)
    assertApiResponse(res)
  })

  test('should not prevent posting skip_enqueue submissions if admin even if daily limit 0', async () => {
    const testConfig = await getTestConfig()
    testConfig.submissions = { global: { dailyLimit: 0 } }
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
    const res = await controller.testPost('/submissions/skip_enqueue', { body: testSubmission }, testAdminJwt)
    assertApiResponse(res)
  })

  test('should not prevent submissions if daily limit null', async () => {
    const testConfig = await getTestConfig()
    testConfig.submissions = { global: { dailyLimit: null } }
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
    const res = await controller.testPost('/submissions', { body: testSubmission }, testUserJwt)
    assertApiResponse(res)
  })

  test('should prevent submissions beyond daily limit', async () => {
    const testConfig = await getTestConfig()
    testConfig.submissions = { global: { dailyLimit: 999 } }
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
    const res = await controller.testPost('/submissions', { body: testSubmission }, testUserJwt)
    assertApiResponse(res)
  })

  test('should deny unauthenticated access to POST submission status', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPost(
      `/submissions/:submission_ids/statuses`,
      {
        params: { submission_ids: submissionUuid },
        body: { status: 'STARTED', message: 'unauthorized attempt' },
      },
      null,
    )
    assertApiResponse(res, StatusCodes.UNAUTHORIZED)
  })

  test('should deny posting status to another user submission', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPost(
      `/submissions/:submission_ids/statuses`,
      {
        params: { submission_ids: submissionUuid },
        body: { status: 'STARTED', message: 'hijack attempt' },
      },
      testOtherUserJwt,
    )
    assertApiResponse(res, StatusCodes.FORBIDDEN)
  })

  test('should allow admin to post status to any submission', async ({ skip }) => {
    const submission = await controller.testPost('/submissions', { body: testSubmission }, testUserJwt)
    assertApiResponse(submission)
    submissionUuid = submission.body.body.id

    const res = await controller.testPost(
      `/submissions/:submission_ids/statuses`,
      {
        params: { submission_ids: submissionUuid },
        body: { status: 'STARTED', message: 'admin override' },
      },
      testAdminJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
    expect(res.body.body.at(0)?.status).toBe('STARTED')
  })

  test('should allow updating submission status', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPost(
      `/submissions/:submission_ids/statuses`,
      {
        params: { submission_ids: submissionUuid },
        body: { status: 'STARTED', message: 'taking off' },
      },
      testUserJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
    expect(res.body.body.at(0)?.status).toBe('STARTED')
    expect(res.body.body.at(0)?.message).toBe('taking off')
  })

  test('should allow inserting same submission status twice', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testPost(
      `/submissions/:submission_ids/statuses`,
      {
        params: { submission_ids: submissionUuid },
        body: { status: 'STARTED', message: 'continuing' },
      },
      testUserJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
    expect(res.body.body.at(0)?.status).toBe('STARTED')
    expect(res.body.body.at(0)?.message).toBe('continuing')
  })

  test('should list submission statuses', async ({ skip }) => {
    if (!submissionUuid) skip()
    const res = await controller.testGet(
      `/submissions/:submission_ids/statuses`,
      {
        params: { submission_ids: submissionUuid },
      },
      testUserJwt,
    )
    assertApiResponse(res)
    // also tests
    // - SUBMITTED was auto-inserted on creation and
    // - statuses are returned in anti-chronological order
    expect(res.body.body).toHaveLength(3)
    expect(res.body.body.at(0)?.status).toBe('STARTED')
    expect(res.body.body.at(0)?.message).toBe('continuing')
    expect(res.body.body.at(1)?.status).toBe('STARTED')
    expect(res.body.body.at(1)?.message).toBe('taking off')
    expect(res.body.body.at(2)?.status).toBe('SUBMITTED')
  })

  test('should fail post submissions with two large value', async () => {
    const testSubmission: StripId<SubmissionRow> = {
      benchmark_id: '20ccc7c1-034c-4880-8946-bffc3fed1359',
      test_ids: ['557d9a00-7e6d-410b-9bca-a017ca7fe3aa'],
      name: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest',
      submission_data_url: 'none',
    }

    const res = await controller.testPost('/submissions', { body: testSubmission }, testUserJwt)
    assertApiResponse(res, StatusCodes.UNPROCESSABLE_ENTITY)
  })

  describe('submission deadline', () => {
    const deadlineBenchmarkId = '20ccc7c1-034c-4880-8946-bffc3fed1359'
    let deadlineController: ControllerTestAdapter

    beforeAll(async () => {
      const testConfig = await getTestConfig()
      deadlineController = new ControllerTestAdapter(SubmissionController, testConfig)
      vi.spyOn(CeleryService.prototype, 'sendTask')
    })

    afterEach(async () => {
      const sql = SqlService.getInstance()
      await sql.query`UPDATE benchmarks SET deadline = NULL WHERE id = ${deadlineBenchmarkId}`
    })

    test('should reject POST /submissions when deadline is in the past', async () => {
      const sql = SqlService.getInstance()
      await sql.query`UPDATE benchmarks SET deadline = NOW() - INTERVAL '1 second' WHERE id = ${deadlineBenchmarkId}`
      const res = await deadlineController.testPost('/submissions', { body: testSubmission }, testUserJwt)
      assertApiResponse(res, StatusCodes.GONE)
    })

    test('should reject POST /submissions/skip_enqueue when deadline is in the past', async () => {
      const sql = SqlService.getInstance()
      await sql.query`UPDATE benchmarks SET deadline = NOW() - INTERVAL '1 second' WHERE id = ${deadlineBenchmarkId}`
      const res = await deadlineController.testPost('/submissions/skip_enqueue', { body: testSubmission }, testUserJwt)
      assertApiResponse(res, StatusCodes.GONE)
    })

    test('should allow admin to POST /submissions/skip_enqueue after deadline has passed', async () => {
      const sql = SqlService.getInstance()
      await sql.query`UPDATE benchmarks SET deadline = NOW() - INTERVAL '1 second' WHERE id = ${deadlineBenchmarkId}`
      const res = await deadlineController.testPost('/submissions/skip_enqueue', { body: testSubmission }, testAdminJwt)
      assertApiResponse(res)
    })

    test('should allow POST /submissions/skip_enqueue when deadline is in the future', async () => {
      const sql = SqlService.getInstance()
      await sql.query`UPDATE benchmarks SET deadline = NOW() + INTERVAL '1 day' WHERE id = ${deadlineBenchmarkId}`
      const res = await deadlineController.testPost('/submissions/skip_enqueue', { body: testSubmission }, testUserJwt)
      assertApiResponse(res)
    })

    test('should allow POST /submissions/skip_enqueue when no deadline is set', async () => {
      const res = await deadlineController.testPost('/submissions/skip_enqueue', { body: testSubmission }, testUserJwt)
      assertApiResponse(res)
    })

    test('should allow POST status update after deadline has passed', async () => {
      const sql = SqlService.getInstance()
      // create submission before setting past deadline
      const createRes = await deadlineController.testPost(
        '/submissions/skip_enqueue',
        { body: testSubmission },
        testUserJwt,
      )
      assertApiResponse(createRes)
      const deadlineSubmissionUuid = createRes.body.body.id
      // now set a past deadline
      await sql.query`UPDATE benchmarks SET deadline = NOW() - INTERVAL '1 second' WHERE id = ${deadlineBenchmarkId}`
      // status update must still succeed
      const res = await deadlineController.testPost(
        '/submissions/:submission_ids/statuses',
        {
          params: { submission_ids: deadlineSubmissionUuid },
          body: {
            status: 'STARTED',
            message: null,
          },
        },
        testUserJwt,
      )
      assertApiResponse(res)
      expect(res.body.body.at(0)?.status).toBe('STARTED')
    })
  })
})
