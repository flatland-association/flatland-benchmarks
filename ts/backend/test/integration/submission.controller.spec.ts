import { Submission } from '@common/interfaces'
import { StripLocator } from '@common/utility-types'
import { JwtPayload } from 'jsonwebtoken'
import { SubmissionController } from '../../src/app/features/controller/submission.controller.mjs'
import { AmqpService } from '../../src/app/features/services/amqp-service.mjs'
import { AuthService } from '../../src/app/features/services/auth-service.mjs'
import { SqlService } from '../../src/app/features/services/sql-service.mjs'
import { ControllerTestAdapter } from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'

const testSubmission: StripLocator<Submission> = {
  name: 'test',
  benchmark: 1,
  submission_image: 'none',
  code_repository: 'none',
  tests: [1, 2],
}

const testJwt: JwtPayload = {
  sub: '10000000-0000-0000-0000-000000000000',
  preferred_username: 'Test',
}

describe.sequential('Submission controller', () => {
  let controller: ControllerTestAdapter
  let submissionUuid: string

  beforeAll(async () => {
    const testConfig = await getTestConfig()
    AmqpService.create(testConfig)
    AuthService.create(testConfig)
    SqlService.create(testConfig)
    controller = new ControllerTestAdapter(SubmissionController, testConfig)
  })

  test('should reject post submissions from unauthorized users', async () => {
    const res = await controller.testPost('/submissions', { body: testSubmission })
    expect(res.status).toBe(401)
    expect(res.body).toBeApiResponse()
  })

  test('should allow post submissions', async () => {
    const res = await controller.testPost('/submissions', { body: testSubmission }, testJwt)
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body?.uuid).toBeTruthy()
    submissionUuid = res.body.body!.uuid
  })

  test('should reject get submissions from unauthorized users', async () => {
    const res = await controller.testGet('/submissions/:uuid', { params: { uuid: submissionUuid } })
    expect(res.status).toBe(401)
    expect(res.body).toBeApiResponse()
  })

  test('should allow get submissions', async () => {
    const res = await controller.testGet('/submissions/:uuid', { params: { uuid: submissionUuid } }, testJwt)
    expect(res.status).toBe(200)
    expect(res.body).toBeApiResponse()
    expect(res.body.body?.at(0)).toBeTruthy()
  })
})
