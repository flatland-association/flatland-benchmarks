import { SubmissionRow } from '@common/interfaces'
import { StripId } from '@common/utility-types'
import { StatusCodes } from 'http-status-codes'
import { MockInstance } from 'vitest'
import { SubmissionController } from '../../src/app/features/controller/submission.controller.mjs'
import { Logger } from '../../src/app/features/logger/logger.mjs'
import { CeleryService } from '../../src/app/features/services/celery-client-service.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
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

  // data set in
  // - ts\backend\src\migration\data\V4.1__ai4realnet_example.sql
  // - ts\backend\src\migration\data\V5.2__publishable_submission.sql
  test('should list published submissions (no user)', async () => {
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
  test('should list submissions for benchmark', async () => {
    const res = await controller.testGet('/submissions', {
      query: { benchmark_ids: '1df5f920-ed2c-4873-957b-723b4b5d81b1' },
    })
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    expect(submissionIds).toContain('a8bb32be-a596-4636-898d-7e1fe7c7492d')
  })

  test('should list own unpublished submissions (user required)', async () => {
    const res = await controller.testGet('/submissions', { query: { unpublished_own: 'true' } }, testUserJwt)
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    expect(submissionIds).toContain(submissionUuid)
  })

  test('should deny listing own unpublished submissions (no user)', async () => {
    const res = await controller.testGet('/submissions', { query: { unpublished_own: 'true' } })
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    expect(submissionIds).not.toContain(submissionUuid)
  })

  test('should return published submission (no user)', async () => {
    const res = await controller.testGet('/submissions/:submission_ids', {
      params: { submission_ids: 'cd4d44bc-d40e-4173-bccb-f04e0be1b2ae' },
    })
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
  })

  test('should deny returning unpublished submission (no user)', async () => {
    const res = await controller.testGet('/submissions/:submission_ids', { params: { submission_ids: submissionUuid } })
    assertApiResponse(res, StatusCodes.NOT_FOUND)
    expect(res.body.body).toHaveLength(0)
  })

  test('should return unpublished own submission (user required)', async () => {
    const res = await controller.testGet(
      '/submissions/:submission_ids',
      { params: { submission_ids: submissionUuid } },
      testUserJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
  })

  test('should allow publishing submissions', async () => {
    const res = await controller.testPatch(
      '/submissions/:submission_ids',
      {
        params: { submission_ids: submissionUuid },
      },
      testUserJwt,
    )
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(1)
  })

  // this only works after publishing the submission
  test('should list submissions by submitter', async () => {
    const res = await controller.testGet('/submissions', {
      query: { submitted_by: testUserJwt.sub },
    })
    assertApiResponse(res)
    const submissionIds = res.body.body.map((s) => s.id)
    expect(submissionIds).toContain(submissionUuid)
  })
})
