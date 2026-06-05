import { beforeAll, describe, expect, test } from 'vitest'
import { SubmissionController } from '../../src/app/features/controller/submission.controller.mjs'
import {
  assertApiResponse,
  ControllerTestAdapter,
  setupControllerTestEnvironment,
  testAdminJwt,
} from '../controller.test-adapter.mjs'
import { getTestConfig } from './setup.mjs'
// Seed data UUIDs inserted by V3.1__new_demo_data.sql / V3.2__new_demo_submission.sql
const BENCHMARK_ID = '20ccc7c1-034c-4880-8946-bffc3fed1359'
const TEST_ID = '557d9a00-7e6d-410b-9bca-a017ca7fe3aa'

let adapter: ControllerTestAdapter

beforeAll(async () => {
  const config = await getTestConfig()
  setupControllerTestEnvironment(config)
  adapter = new ControllerTestAdapter(SubmissionController, config)
})

describe('SubmissionController – UTC timestamps', () => {
  test('submitted_at is returned as a UTC ISO string', async () => {
    const before = new Date()
    const post = await adapter.testPost(
      '/submissions/skip_enqueue',
      {
        body: {
          benchmark_id: BENCHMARK_ID,
          test_ids: [TEST_ID],
          name: 'utc-test-submitted-at',
          submission_data_url: 'http://example.com/submission',
        },
      },
      testAdminJwt,
    )
    const after = new Date()
    assertApiResponse(post)

    const submissionId = post.body.body!.id
    const get = await adapter.testGet(
      '/submissions/:submission_ids',
      { params: { submission_ids: submissionId } },
      testAdminJwt,
    )
    assertApiResponse(get)
    const submission = get.body.body![0]

    // Timestamp must be a UTC ISO string (Z suffix) regardless of the DB session timezone.
    // With a `timestamp without time zone` column this would fail in non-UTC server environments.
    expect(submission.submitted_at).toMatch(/Z$/)
    const submittedAt = new Date(submission.submitted_at!)
    expect(submittedAt.getTime()).toBeGreaterThanOrEqual(before.getTime())
    expect(submittedAt.getTime()).toBeLessThanOrEqual(after.getTime() + 1000)
  })

  test('submission status timestamp is returned as a UTC ISO string', async () => {
    // Create a submission to attach statuses to
    const post = await adapter.testPost(
      '/submissions/skip_enqueue',
      {
        body: {
          benchmark_id: BENCHMARK_ID,
          test_ids: [TEST_ID],
          name: 'utc-test-status',
          submission_data_url: 'http://example.com/submission',
        },
      },
      testAdminJwt,
    )
    assertApiResponse(post)
    const submissionId = post.body.body!.id

    // Post a status update and capture the returned statuses
    const before = new Date()
    const postStatus = await adapter.testPost(
      '/submissions/:submission_ids/statuses',
      {
        params: { submission_ids: submissionId },
        body: { status: 'STARTED', message: null },
      },
      testAdminJwt,
    )
    const after = new Date()
    assertApiResponse(postStatus)

    // Verify every returned status timestamp is a UTC ISO string
    for (const status of postStatus.body.body!) {
      expect(status.timestamp).toMatch(/Z$/)
      const ts = new Date(status.timestamp)
      expect(ts.getTime()).toBeGreaterThanOrEqual(before.getTime())
      expect(ts.getTime()).toBeLessThanOrEqual(after.getTime() + 1000)
    }
  })
})
