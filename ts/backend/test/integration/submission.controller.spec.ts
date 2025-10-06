import { SubmissionRow } from '@common/interfaces'
import { StripLocator } from '@common/utility-types'
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

const testSubmission: StripLocator<SubmissionRow> = {
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

  test('should return published submission (no user)', async () => {
    const res = await controller.testGet('/submissions/:submission_ids', { params: { submission_ids: submissionUuid } })
    assertApiResponse(res)
  })

  test('should deny returning unpublished submission (no user)', async () => {
    const res = await controller.testGet('/submissions/:submission_ids', { params: { submission_ids: submissionUuid } })
    assertApiResponse(res)
    expect(res.body.body).toHaveLength(0)
  })

  test('should return unpublished own submission (user required)', async () => {
    const res = await controller.testGet(
      '/submissions/:submission_ids',
      { params: { submission_ids: submissionUuid } },
      testUserJwt,
    )
    assertApiResponse(res)
  })
})
