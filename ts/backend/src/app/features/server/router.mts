import amqp from 'amqplib'
import type { Request } from 'express'
import express from 'express'
import wait from '../utils/wait.mjs'
import { Server } from './server.mjs'

/**
 * Returns a short recap of requested endpoint (method + url).
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

  return router
}
