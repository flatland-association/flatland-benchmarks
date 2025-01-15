import amqp from 'amqplib'
import type { Request } from 'express'
import express from 'express'
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

export function router(server: Server) {
  const router = express.Router()

  // Returns JSON excerpt of request
  router.get('/mirror', (req, res) => {
    console.log(dbgRequestEndpoint(req))
    res.json(dbgRequestObject(req))
  })

  // Returns JSON excerpt of request
  router.get('/mirror/:id', (req, res) => {
    console.log(dbgRequestEndpoint(req))
    res.json(dbgRequestObject(req))
  })

  // Returns JSON excerpt of request
  router.post('/mirror', (req, res) => {
    console.log(dbgRequestEndpoint(req))
    res.json(dbgRequestObject(req))
  })

  // Returns last message in amqp queue
  router.get('/amqp', async (req, res, next) => {
    try {
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
      res.json(`relayed from "debug": ${message ?? null}`)
    } catch (error) {
      next(error)
    }
  })

  // Posts a message to amqp queue
  router.post('/amqp', async (req, res, next) => {
    try {
      console.log(dbgRequestEndpoint(req))
      // connect to debug queue on rabbitmq server
      const connection = await amqp.connect(`amqp://${server.config.amqp.host}:${server.config.amqp.port}`)
      const channel = await connection.createChannel()
      channel.assertQueue('debug', { durable: false })
      // send message
      channel.sendToQueue('debug', Buffer.from(JSON.stringify(req.body)))
      // report what was sent
      res.json(`relayed to "debug": ${JSON.stringify(req.body)}`)
    } catch (error) {
      next(error)
    }
  })

  // Sets up tables in database
  router.get('/dbsetup', async (req, res) => {
    const sql = SqlService.getInstance()
    const result = await sql?.setup()
    res.json(result)
  })

  // apiService.post('submissions', {submission_image: "ghcr.io/flatland-association/fab-flatland-submission-template:latest"})
  router.post('/submissions', async (req, res) => {
    const submission_image = req.body.submission_image
    if (typeof submission_image !== 'string') {
      res.json('ERROR: `submission_image` must be string')
      return
    }
    // save submission in db
    const sql = SqlService.getInstance()
    if (!sql) {
      res.json('ERROR: SqlService not available')
      return
    }
    const idRow = await sql.query`
      INSERT INTO submissions (
        submission_image
      ) VALUES (
        ${submission_image}
      )
      RETURNING id
    `
    const id = idRow.at(0)?.['id'] ?? 'null'
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
    res.json(idRow)
  })

  router.get('/submissions', async (req, res) => {
    const sql = SqlService.getInstance()
    if (!sql) {
      res.json('ERROR: SqlService not available')
      return
    }
    const submissions = await sql.query`
      SELECT * FROM submissions
      ORDER BY id ASC
    `
    res.json(submissions)
  })

  router.get('/submissions/:id', async (req, res, next) => {
    const id = req.params.id
    try {
      const client = await createClient()
        .on('error', (err) => console.log('Redis Client Error', err))
        .connect()

      // console.log(await client.keys('*'))

      const keys = await client.keys(`*-sub${id}`)

      if (!keys || keys.length == 0) {
        res.json(null)
        return
      }

      // assume keys[0] is the one we're interested in
      const key = keys[0]
      const value = JSON.parse((await client.get(key)) ?? 'null')

      await client.disconnect()
      res.json(value)
    } catch (error) {
      next(error)
    }
  })

  // TODO: /submission/:id/run to queue run

  return router
}
