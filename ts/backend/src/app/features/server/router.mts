import type { ApiGetEndpoints, ApiPatchEndpoints, ApiPostEndpoints } from '@common/api-endpoints.mjs'
import { ApiResponse } from '@common/api-response.mjs'
import { appendDir } from '@common/endpoint-utils.mjs'
import { Benchmark, BenchmarkPreview, Result, Submission, SubmissionPreview, Test } from '@common/interfaces.mjs'
import { StripDir } from '@common/utility-types.mjs'
import type { NextFunction, Request, Response, Router } from 'express'
import express from 'express'
import type { RequestHandler, RouteParameters } from 'express-serve-static-core'
import { createClient } from 'redis'
import { AmpqService } from '../services/ampq-service.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Schema } from '../setup/schema.mjs'
import { Server } from './server.mjs'

/**
 * Returns a short recap of requested endpoint (method + url) for logging.
 */
function dbgRequestEndpoint(req: Request) {
  return `${req.method} ${req.url}`
}

/**
 * Returns an object based off Request reduced to the valuable information.
 */
function dbgRequestObject(req: Request) {
  return {
    // full request URL (e.g. /mirror/1?test=2&tester=3)
    url: req.url,
    // query params (e.g. {test: 2, tester: 3})
    query: req.query,
    // path (e.g. /mirror/1)
    path: req.path,
    // params (e.g. {id: 1})
    params: req.params,
    // body (JSON, e.g. when POST requesting)
    body: req.body,
  }
}

/**
 * Returns an object based off current SqlService state.
 * @param sql SqlService instance
 */
function dbgSqlState(sql: SqlService) {
  return {
    notices: sql.notices,
    errors: sql.errors,
    statement: sql.statement,
  }
}

/*
The wrapper functions serve two purposes:
1. They provide a common try catch wrap around the handler.
2. they allow type inferring from route (Express' types are too convoluted to
   be overriden by declares IMHO).
*/

// typed overload
/**
 * Attach a GET endpoint handler.
 * @param router Express router.
 * @param endpoint String represantation of the route.
 * @param handler Handler function.
 * @see {@link ApiGetEndpoints}
 */
function attachGet<E extends keyof ApiGetEndpoints>(
  router: Router,
  endpoint: E,
  handler: (
    req: Request<RouteParameters<E>, unknown, ApiGetEndpoints[E]['request']['body']>,
    res: Response<ApiGetEndpoints[E]['response']>,
    next: NextFunction,
  ) => void | Promise<void>,
): void
// un-typed fallback overload
// function attachGet(router: Router, endpoint: string, handler: RequestHandler): void

function attachGet(router: Router, endpoint: string, handler: RequestHandler) {
  router.get(endpoint, async (req, res, next) => {
    try {
      await handler(req, res, next)
    } catch (error) {
      next(error)
    }
  })
}

// typed overload
/**
 * Attach a POST endpoint handler.
 * @param router Express router.
 * @param endpoint String represantation of the route.
 * @param handler Handler function.
 * @see {@link ApiPostEndpoints}
 */
function attachPost<E extends keyof ApiPostEndpoints>(
  router: Router,
  endpoint: E,
  handler: (
    req: Request<RouteParameters<E>, unknown, ApiPostEndpoints[E]['request']['body']>,
    res: Response<ApiPostEndpoints[E]['response']>,
    next: NextFunction,
  ) => void | Promise<void>,
): void
// un-typed fallback overload
// function attachPost(router: Router, endpoint: string, handler: RequestHandler): void

function attachPost(router: Router, endpoint: string, handler: RequestHandler) {
  router.post(endpoint, async (req, res, next) => {
    try {
      await handler(req, res, next)
    } catch (error) {
      next(error)
    }
  })
}

// typed overload
/**
 * Attach a PATCH endpoint handler.
 * @param router Express router.
 * @param endpoint String represantation of the route.
 * @param handler Handler function.
 * @see {@link ApiPatchEndpoints}
 */
function attachPatch<E extends keyof ApiPatchEndpoints>(
  router: Router,
  endpoint: E,
  handler: (
    req: Request<RouteParameters<E>, unknown, ApiPatchEndpoints[E]['request']['body']>,
    res: Response<ApiPatchEndpoints[E]['response']>,
    next: NextFunction,
  ) => void | Promise<void>,
): void
// un-typed fallback overload
// function attachPatch(router: Router, endpoint: string, handler: RequestHandler): void

function attachPatch(router: Router, endpoint: string, handler: RequestHandler) {
  router.patch(endpoint, async (req, res, next) => {
    try {
      await handler(req, res, next)
    } catch (error) {
      next(error)
    }
  })
}

/**
 * Send a well-typed JSON response with optional debug info.
 * @param res Express response.
 * @param body Response body. Type is derived from endpoint registry.
 * @param dbg Additional debug info.
 * @see {@link ApiResponse}
 */
function respond<T>(res: Response<ApiResponse<T>>, body: T, dbg?: unknown) {
  res.json({
    body: body,
    dbg,
  })
}

/**
 * Send a well-typed error with code 400 (Bad request), additional error text
 * and optional debug info.
 * @param res Express response.
 * @param error Error object.
 * @param dbg Additional debug info.
 * @see {@link ApiResponse}
 */
function requestError<T>(res: Response<ApiResponse<T>>, error: ApiResponse<T>['error'], dbg?: unknown) {
  res.status(400)
  res.json({
    error,
    dbg,
  })
}

/**
 * Send a well-typed error with code 401 (Unauthorized), additional
 * error text and optional debug info.
 * @param res Express response.
 * @param error Error object.
 * @param dbg Additional debug info.
 * @see {@link ApiResponse}
 */
function unauthorizedError<T>(res: Response<ApiResponse<T>>, error: ApiResponse<T>['error'], dbg?: unknown) {
  res.status(401)
  res.json({
    error,
    dbg,
  })
}

/**
 * Send a well-typed error with code 500 (Internal server error), additional
 * error text and optional debug info.
 * @param res Express response.
 * @param error Error object.
 * @param dbg Additional debug info.
 * @see {@link ApiResponse}
 */
function serverError<T>(res: Response<ApiResponse<T>>, error: ApiResponse<T>['error'], dbg?: unknown) {
  res.status(500)
  res.json({
    error,
    dbg,
  })
}

export function router(_server: Server) {
  const router = express.Router()

  // mirror endpoints - for dev/debug purposes
  attachGet(router, '/mirror', (req, res) => {
    respond(res, 'This is the /mirror endpoint', dbgRequestObject(req))
  })

  attachGet(router, '/mirror/:id', (req, res) => {
    respond(res, 'This is the /mirror/:id endpoint', dbgRequestObject(req))
  })

  attachPost(router, '/mirror', (req, res) => {
    // do not set body.data to see `requestError` in action
    // do not set body at all to see fallback error handling in action
    if (!req.body.data) {
      requestError(res, { text: 'No data set in request body' })
      return
    } else {
      respond(res, req.body, dbgRequestObject(req))
    }
  })

  // Returns last message in amqp queue
  attachGet(router, '/ampq', async (req, res) => {
    console.log(dbgRequestEndpoint(req))
    const ampq = AmpqService.getInstance()
    const channel = await ampq.getChannel()
    // Using the pull API is *perfectly* fine here because this is a debug
    // method for dev purposes only.
    const message = await channel?.get('debug', { noAck: true })
    if (message) {
      respond(res, `relayed from "debug": ${message.content.toString() ?? null}`)
    } else {
      respond(res, 'no messages to relay from "debug"')
    }
  })

  // Posts a message to amqp queue
  attachPost(router, '/ampq', async (req, res) => {
    console.log(dbgRequestEndpoint(req))
    // send message to debug queue
    const ampq = AmpqService.getInstance()
    const sent = await ampq.sendToQueue('debug', req.body)
    // report what was sent
    if (sent) {
      respond(res, `relayed to "debug": ${JSON.stringify(req.body)}`)
    } else {
      respond(res, 'There was an error sending the message. Check backend log.')
    }
  })

  // Sets up tables in database
  attachGet(router, '/dbsetup', async (req, res) => {
    Schema.setup()
    respond(res, null)
  })

  // auth test endpoints - for dev/debug purposes
  attachGet(router, '/whoami', async (req, res) => {
    const auth = AuthService.getInstance()
    auth
      .authorization(req)
      .then((jwtp) => {
        const iam = jwtp
          ? {
              id: jwtp.sub,
              email: jwtp['email'],
              name: jwtp['name'],
            }
          : null
        respond(res, iam, jwtp)
      })
      .catch((err) => {
        serverError(res, err)
      })
  })

  attachGet(router, '/benchmarks', async (req, res) => {
    const sql = SqlService.getInstance()
    const rows = await sql.query<StripDir<BenchmarkPreview>>`
      SELECT id, name, description FROM benchmarks
      ORDER BY id ASC
    `
    const resources = appendDir('/benchmarks/', rows)
    respond(res, resources)
  })
  attachGet(router, '/benchmarks/:id', async (req, res) => {
    const ids = req.params.id.split(',').map((s) => +s)
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<Benchmark>>`
      SELECT * FROM benchmarks
      WHERE id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const benchmarks = appendDir('/benchmarks/', rows)
    respond(res, benchmarks)
  })

  attachGet(router, '/tests/:id', async (req, res) => {
    const ids = req.params.id.split(',').map((s) => +s)
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<Test>>`
      SELECT * FROM tests
      WHERE id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const tests = appendDir('/tests/', rows)
    // return array - dev.002
    respond(res, tests)
  })

  // apiService.post('submissions', {submission_image: "ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest"})
  attachPost(router, '/submissions', async (req, res) => {
    const authService = AuthService.getInstance()
    const auth = await authService.authorization(req)
    if (!auth) {
      unauthorizedError(res, { text: 'Not authorized' })
      return
    }
    // save submission in db
    const sql = SqlService.getInstance()
    const idRow = await sql.query`
      INSERT INTO submissions (
        benchmark,
        submission_image,
        code_repository,
        tests,
        submitted_at,
        submitted_by,
        submitted_by_username
      ) VALUES (
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
      serverError(res, { text: `could not insert submission` }, { id, uuid })
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
    const ampq = AmpqService.getInstance()
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
    const sent = await ampq.sendToQueue('celery', payload, {
      headers: {
        task: 'flatland3-evaluation',
        id: `sub-${uuid}`,
      },
      contentType: 'application/json',
      persistent: true,
    })
    if (sent) {
      respond(res, { uuid }, payload)
    } else {
      respond(res, { uuid }, 'Could not send message to AMQP service. Check backend log.')
    }
  })

  // returns scored and public submissions as preview
  attachGet(router, '/submissions', async (req, res) => {
    const benchmarkId = req.query['benchmark'] as string | undefined
    const submissionUuids = (req.query['uuid'] as string | undefined)?.split(',')

    const sql = SqlService.getInstance()

    let whereScores = sql.fragment`results.scores IS NOT NULL`
    let wherePublic = sql.fragment`results.public = true`
    const whereBenchmark = benchmarkId ? sql.fragment`benchmark=${benchmarkId}` : sql.fragment`1=1`
    let whereSubmission = sql.fragment`1=1`
    let limit = 3
    if (submissionUuids) {
      // turn off scores and public requirements if id is given
      whereScores = sql.fragment`1=1`
      wherePublic = sql.fragment`1=1`
      whereSubmission = sql.fragment`submissions.uuid=ANY(${submissionUuids})`
      limit = submissionUuids.length
    }

    const rows = await sql.query<StripDir<SubmissionPreview>>`
      SELECT submissions.id, submissions.uuid, benchmark, submitted_at, submitted_by_username, scores
        FROM submissions
        LEFT JOIN results ON results.submission_uuid = submissions.uuid
        WHERE
          ${whereScores} AND
          ${wherePublic} AND
          ${whereBenchmark} AND
          ${whereSubmission}
        ORDER BY scores[1] DESC
        LIMIT ${limit}
    `
    const resources = appendDir('/submissions/', rows)
    respond(res, resources, { dbg: dbgRequestObject(req), sql: dbgSqlState(sql) })
  })

  attachGet(router, '/submissions/:uuid', async (req, res) => {
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
    respond(res, submissions)
  })

  attachGet(router, '/submissions/:uuid/results', async (req, res) => {
    const uuid = req.params.uuid
    const sql = SqlService.getInstance()
    const [row] = await sql.query<StripDir<Result>>`
      SELECT * FROM results
      WHERE submission_uuid=${uuid}
    `

    // try updating incomplete (no done_at) results
    if (!row.done_at) {
      const client = await createClient({ url: _server.config.redis.url })
        .on('error', (err) => console.log('Redis Client Error', err))
        .connect()
      const keys = await client.keys(`*-sub-${uuid}`)

      if (keys && keys.length > 0) {
        // assume keys[0] is the one we're interested in
        const key = keys[0]
        const value = JSON.parse((await client.get(key)) ?? 'null')

        if (value) {
          // date_done could probably be fed directly into DB, but for response the date should be reformatted
          row.done_at = new Date(value['date_done']).toISOString()
          row.success = value['status'] === 'SUCCESS'
          // (only) on success, try reading score
          if (row.success) {
            // currently hardcoded: result scheme
            const resultScheme = 'f3-evaluator'
            const results = {
              'results.csv': value['result'][resultScheme]['results.csv'],
              'results.json': value['result'][resultScheme]['results.json'],
            }
            // save original results "object"
            row.results_str = JSON.stringify(results)
            const resultsJson = JSON.parse(results['results.json'])
            const scores = resultsJson['score']
            // extract N-scores from results
            row.scores = [scores['score'], scores['score_secondary']]
          }

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
      await client.disconnect()
    }

    const results = appendDir('/results/', [row])
    respond(res, results)
  })

  attachPatch(router, '/result', async (req, res) => {
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
    respond(res, result)
  })

  return router
}
