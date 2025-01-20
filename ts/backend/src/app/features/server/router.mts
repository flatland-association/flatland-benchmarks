import type { ApiGetEndpoints, ApiPostEndpoints } from '@common/api-endpoints.mjs'
import { ApiResponse } from '@common/api-response.mjs'
import amqp from 'amqplib'
import type { NextFunction, Request, Response, Router } from 'express'
import express from 'express'
import type { RequestHandler, RouteParameters } from 'express-serve-static-core'
import { createClient } from 'redis'
import { SqlService } from '../services/sql-service.mjs'
import wait from '../utils/wait.mjs'
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

export function router(server: Server) {
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
    // connect to debug queue on rabbitmq server
    const connection = await amqp.connect(`amqp://${server.config.amqp.host}:${server.config.amqp.port}`)
    const channel = await connection.createChannel()
    channel.assertQueue('debug', { durable: false })
    // consume messages
    let message: string | undefined = undefined
    channel.consume('debug', (msg) => {
      message = msg?.content.toString()
    })
    // await timeout (gives back control to main event loop for the consume callback)
    await wait(100)
    // close connection
    connection.close()
    // report last consumed message
    respond(res, `relayed from "debug": ${message ?? null}`)
  })

  // Posts a message to amqp queue
  attachPost(router, '/ampq', async (req, res) => {
    console.log(dbgRequestEndpoint(req))
    // connect to debug queue on rabbitmq server
    const connection = await amqp.connect(`amqp://${server.config.amqp.host}:${server.config.amqp.port}`)
    const channel = await connection.createChannel()
    channel.assertQueue('debug', { durable: false })
    // send message
    channel.sendToQueue('debug', Buffer.from(JSON.stringify(req.body)))
    // report what was sent
    respond(res, `relayed to "debug": ${JSON.stringify(req.body)}`)
  })

  // Sets up tables in database
  attachGet(router, '/dbsetup', async (req, res) => {
    const sql = SqlService.getInstance()
    const result = await sql.setup()
    respond(res, result)
  })

  // apiService.post('submissions', {submission_image: "ghcr.io/flatland-association/fab-flatland-submission-template:latest"})
  attachPost(router, '/submissions', async (req, res) => {
    const submission_image = req.body.submission_image
    if (typeof submission_image !== 'string') {
      requestError(res, { text: '`submission_image` must be string' })
      return
    }
    // save submission in db
    const sql = SqlService.getInstance()
    const idRow = await sql.query`
      INSERT INTO submissions (
        submission_image
      ) VALUES (
        ${submission_image}
      )
      RETURNING id
    `
    const id: number = idRow.at(0)?.['id'] ?? 0
    // start evaluator
    const connection = await amqp.connect(`amqp://${server.config.amqp.host}:${server.config.amqp.port}`)
    const channel = await connection.createChannel()
    channel.assertQueue('celery', { durable: true })
    const payload = [
      [],
      {
        docker_image: 'ghcr.io/flatland-association/fab-flatland-evaluator:latest',
        submission_image: submission_image,
      },
      {
        callbacks: null,
        errbacks: null,
        chain: null,
        chord: null,
      },
    ]
    channel.sendToQueue('celery', Buffer.from(JSON.stringify(payload)), {
      headers: {
        task: 'flatland3-evaluation',
        id: `sub${id}`,
      },
      contentType: 'application/json',
      persistent: true,
    })
    respond(res, { id })
  })

  attachGet(router, '/submissions', async (req, res) => {
    const sql = SqlService.getInstance()
    const submissions = await sql.query`
      SELECT * FROM submissions
      ORDER BY id ASC
    `
    respond(res, submissions)
  })

  attachGet(router, '/submissions/:id', async (req, res) => {
    const id = req.params.id
    const client = await createClient()
      .on('error', (err) => console.log('Redis Client Error', err))
      .connect()

    // console.log(await client.keys('*'))

    const keys = await client.keys(`*-sub${id}`)

    if (!keys || keys.length == 0) {
      respond(res, null)
      return
    }

    // assume keys[0] is the one we're interested in
    const key = keys[0]
    const value = JSON.parse((await client.get(key)) ?? 'null')

    await client.disconnect()
    respond(res, value)
  })

  // TODO: /submission/:id/run to queue run

  return router
}
