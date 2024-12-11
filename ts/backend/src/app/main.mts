import amqp from 'amqplib'
import styles from 'ansi-styles'
import cors from 'cors'
import type { Request } from 'express'
import express from 'express'
import { loadConfig } from './features/config/config.mjs'
// import http from 'node:http'

const config = loadConfig()

const app = express()

app.use(cors())
app.use(express.json())

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

// Returns JSON excerpt of request
app.get('/mirror', (req, res) => {
  console.log(dbgRequestEndpoint(req))
  res.json(dbgRequestObject(req))
})

// Returns JSON excerpt of request
app.get('/mirror/:id', (req, res) => {
  console.log(dbgRequestEndpoint(req))
  res.json(dbgRequestObject(req))
})

// Returns JSON excerpt of request
app.post('/mirror', (req, res) => {
  console.log(dbgRequestEndpoint(req))
  res.json(dbgRequestObject(req))
})

// Returns last message in amqp queue
app.get('/amqp', async (req, res) => {
  console.log(dbgRequestEndpoint(req))
  // connect to debug queue on rabbitmq server
  const connection = await amqp.connect(`amqp://${config.amqp.host}:${config.amqp.port}`)
  const channel = await connection.createChannel()
  channel.assertQueue('debug', { durable: false })
  // consume messages
  let message: string | undefined = undefined
  channel.consume('debug', (msg) => {
    message = msg?.content.toString()
  })
  // await timeout (gives back control to main event loop for the consume callback)
  await new Promise<void>((resolve) => {
    setTimeout(() => {
      resolve()
    }, 100)
  })
  // close connection
  connection.close()
  // report last consumed message
  res.json(`relayed from "debug": ${message ?? null}`)
})

// Posts a message to amqp queue
app.post('/amqp', async (req, res) => {
  console.log(dbgRequestEndpoint(req))
  // connect to debug queue on rabbitmq server
  const connection = await amqp.connect(`amqp://${config.amqp.host}:${config.amqp.port}`)
  const channel = await connection.createChannel()
  channel.assertQueue('debug', { durable: false })
  // send message
  channel.sendToQueue('debug', Buffer.from(JSON.stringify(req.body)))
  // report what was sent
  res.json(`relayed to "debug": ${JSON.stringify(req.body)}`)
})

// start express server
app.listen(config.api.port, config.api.host, () => {
  console.log(`${styles.green.open}server is now live on ${config.api.host}:${config.api.port}`, styles.green.close)
})
