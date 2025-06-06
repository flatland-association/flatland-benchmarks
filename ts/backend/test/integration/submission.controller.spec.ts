import { SubmissionRow } from '@common/interfaces'
import { StripLocator } from '@common/utility-types'
import { SubmissionController } from '../../src/app/features/controller/submission.controller.mjs'
import { ControllerTestAdapter, setupControllerTestEnvironment, testUserJwt } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

const testSubmission: StripLocator<SubmissionRow> = {
  benchmark_definition_id: '20ccc7c1-034c-4880-8946-bffc3fed1359',
  test_definition_ids: ['79094281-35ff-484d-a687-cccb228a04a0'],
  name: 'test',
  submission_data_url: 'none',
}

describe.sequential('Submission controller', () => {
  let controller: ControllerTestAdapter
  let submissionUuid: string

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    setupControllerTestEnvironment(testConfig)
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
  })

  test('should reject post submissions from unauthorized users', async () => {
    const res = await controller.testPost('/submissions', { body: testSubmission })
    expect(res.status).toBe(401)
    expect(res.body).toBeApiResponse()
  })

  test('should allow post submissions', async () => {
    const res = await controller.testPost('/submissions', { body: testSubmission }, testUserJwt)
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body?.id).toBeTruthy()
    submissionUuid = res.body.body!.id
  })

  test('should reject get submissions from unauthorized users', async () => {
    const res = await controller.testGet('/submissions/:uuid', { params: { uuid: submissionUuid } })
    expect(res.status).toBe(401)
    expect(res.body).toBeApiResponse()
  })

  test('should allow get submissions', async () => {
    const res = await controller.testGet('/submissions/:uuid', { params: { uuid: submissionUuid } }, testUserJwt)
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body?.at(0)).toBeTruthy()
  })
})
