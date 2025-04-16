import { appendDir } from '@common/endpoint-utils.js'
import { Result, Submission, SubmissionPreview } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AmqpService } from '../services/amqp-service.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { MinioService } from '../services/minio-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler, PatchHandler, PostHandler } from './controller.mjs'

const logger = new Logger('submission-controller')

export class SubmissionController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachPost('/submissions', this.postSubmission)
    this.attachGet('/submissions', this.getSubmissions)
    this.attachGet('/submissions/:uuid', this.getSubmissionByUuid)
    this.attachGet('/submissions/:uuid/results', this.getSubmissionByUuidResults)
    this.attachPatch('/result', this.patchResult)
  }

  postSubmission: PostHandler<'/submissions'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    // save submission in db
    const sql = SqlService.getInstance()
    const idRow = await sql.query`
        INSERT INTO submissions (
          name,
          benchmark,
          submission_image,
          code_repository,
          tests,
          submitted_at,
          submitted_by,
          submitted_by_username
        ) VALUES (
          ${req.body.name},
          ${req.body.benchmark},
          ${req.body.submission_image},
          ${req.body.code_repository},
          ${req.body.tests},
          current_timestamp,
          ${auth.sub ?? null},
          ${auth['preferred_username'] ?? null}
        )
        RETURNING id, uuid
      `
    const id: number | undefined = idRow.at(0)?.['id']
    const uuid: string | undefined = idRow.at(0)?.['uuid']
    if (!id || !uuid) {
      this.serverError(res, { text: `could not insert submission` }, { id, uuid })
      return
    }
    // prepare results entry
    await sql.query`
        INSERT INTO results (
          submission,
          submission_uuid
        ) VALUES (
          ${id},
          ${uuid}
        )
      `
    // get benchmark docker image
    const [{ docker_image: dockerImage }] = await sql.query`
        SELECT docker_image FROM benchmarks
        WHERE id=${req.body.benchmark}
      `
    // get test names
    const tests = (
      await sql.query<{ name: string }>`
          SELECT name FROM tests
          WHERE id=ANY(${req.body.tests})
          LIMIT ${req.body.tests.length}
        `
    ).map((r) => r.name)
    // start evaluator
    const amqp = AmqpService.getInstance()
    const payload = [
      [],
      {
        docker_image: dockerImage,
        submission_image: req.body.submission_image,
        tests: tests,
      },
      {
        callbacks: null,
        errbacks: null,
        chain: null,
        chord: null,
      },
    ]
    const sent = await amqp.sendToQueue('celery', payload, {
      headers: {
        task: 'flatland3-evaluation',
        id: `sub-${uuid}`,
      },
      contentType: 'application/json',
      persistent: true,
    })
    if (sent) {
      this.respond(res, { uuid }, payload)
    } else {
      this.respond(res, { uuid }, 'Could not send message to AMQP service. Check backend log.')
    }
  }

  // returns scored and public submissions as preview
  getSubmissions: GetHandler<'/submissions'> = async (req, res) => {
    const benchmarkId = req.query['benchmark'] as string | undefined
    const submissionUuids = (req.query['uuid'] as string | undefined)?.split(',')
    const submittedBy = req.query['submitted_by'] as string | undefined

    const sql = SqlService.getInstance()

    let whereScores = sql.fragment`scores IS NOT NULL`
    let wherePublic = sql.fragment`public = true`
    const whereBenchmark = benchmarkId ? sql.fragment`benchmark=${benchmarkId}` : sql.fragment`1=1`
    let whereSubmission = sql.fragment`1=1`
    let whereSubmittedBy = sql.fragment`1=1`
    let limit = sql.fragment`LIMIT 3`
    if (submissionUuids) {
      // turn off scores and public requirements if id is given
      whereScores = sql.fragment`1=1`
      wherePublic = sql.fragment`1=1`
      whereSubmission = sql.fragment`submissions.uuid=ANY(${submissionUuids})`
      limit = sql.fragment`LIMIT ${submissionUuids.length}`
    }
    if (submittedBy) {
      // turn off limit, scores and public requirements if submitter is given
      whereScores = sql.fragment`1=1`
      wherePublic = sql.fragment`1=1`
      whereSubmittedBy = sql.fragment`submitted_by=${submittedBy}`
      limit = sql.fragment``
    }

    const rows = await sql.query<StripDir<SubmissionPreview>>`
        SELECT submissions.id, submissions.uuid, name, benchmark, submitted_at, submitted_by_username, public, scores, rank
          FROM (
            SELECT submissions.id, submissions.uuid, name, benchmark, submitted_at, submitted_by_username, public, scores, rank() OVER(PARTITION BY benchmark, public ORDER BY scores[1] DESC) AS rank, submitted_by
              FROM submissions
              LEFT JOIN results ON results.submission_uuid = submissions.uuid
          ) AS submissions
          WHERE
            ${whereScores} AND
            ${wherePublic} AND
            ${whereBenchmark} AND
            ${whereSubmission} AND
            ${whereSubmittedBy}
          ORDER BY scores[1] DESC
          ${limit}
      `
    const resources = appendDir('/submissions/', rows)
    this.respond(res, resources)
  }

  getSubmissionByUuid: GetHandler<'/submissions/:uuid'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    const uuids = req.params.uuid.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<Submission>>`
        SELECT * FROM submissions
        WHERE uuid=ANY(${uuids})
        LIMIT ${uuids.length}
      `
    const submissions = appendDir('/submissions/', rows)
    // return array - dev.002
    this.respond(res, submissions)
  }

  getSubmissionByUuidResults: GetHandler<'/submissions/:uuid/results'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    const uuid = req.params.uuid
    const sql = SqlService.getInstance()
    const [row] = await sql.query<StripDir<Result>>`
      SELECT * FROM results
      WHERE submission_uuid=${uuid}
    `

    // try updating incomplete (no done_at) results
    if (!row.done_at) {
      const minio = MinioService.getInstance()

      /*
      ⚠ Flatland-3 specific format ⚠
      TODO: generic format, see https://github.com/flatland-association/flatland-benchmarks/issues/178
      */
      const resultsStat = await minio.getFileStat(`sub-${uuid}.json`)
      // assume if json exists csv exists too
      if (resultsStat) {
        // const resultsStat = await minio.getFileStat(`sub-${uuid}.json`)
        const resultsJSONString = await minio.getFileContents(`sub-${uuid}.json`)
        const resultsCSVString = await minio.getFileContents(`sub-${uuid}.csv`)
        if (resultsJSONString && resultsCSVString) {
          // build results_str as object with same structure as pre-s3 results_str, except it's only necessary fields
          const results = {
            result: {
              'f3-evaluator': {
                'results.json': resultsJSONString,
                'results.csv': resultsCSVString,
              },
            },
          }
          // extract score from json
          const resultsJSON = JSON.parse(resultsJSONString)
          const score = resultsJSON['score']
          row.scores = [score['score'], score['score_secondary']]
          // assume success if results are present
          row.success = true
          // file could get modified after first fetch but db row won't be updated so last modified is a good indicator
          row.done_at = new Date(resultsStat.lastModified).toISOString()
          row.results_str = JSON.stringify(results)

          // update result in DB
          await sql.query`
            UPDATE results
              SET
                done_at = ${row.done_at},
                success = ${row.success},
                scores = ${row.scores},
                results_str = ${row.results_str}
              WHERE uuid = ${row.uuid}
          `
        }
      }
    }

    const results = appendDir('/results/', [row])
    this.respond(res, results)
  }

  patchResult: PatchHandler<'/result'> = async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      this.unauthorizedError(res, { text: 'Not authorized' })
      return
    }

    const uuid = req.body.uuid
    // restrict to patchable fields
    const patch = {
      public: req.body.public,
    }
    const sql = SqlService.getInstance()
    const [row] = await sql.query<StripDir<Result>>`
      UPDATE results SET ${sql.fragment(patch, 'public')}
        WHERE uuid=${uuid}
        RETURNING *
    `

    const [result] = appendDir('/results/', [row])
    this.respond(res, result)
  }
}
