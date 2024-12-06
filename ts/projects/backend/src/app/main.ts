import cors from 'cors'
import type { Request } from 'express'
import express from 'express'
import { readFileSync } from 'node:fs'
// import http from 'node:http'

// references:
// https://en.wikipedia.org/wiki/ANSI_escape_code
// https://stackoverflow.com/a/40560590/10135201
// TODO: move this to a module (this has to be an existing NPM module, right?)
const ansiEscapes = {
  reset: '\x1b[0m',
  colors: {
    fg: {
      black: '\x1b[30m',
      red: '\x1b[31m',
      green: '\x1b[32m',
      yellow: '\x1b[33m',
      blue: '\x1b[34m',
      magenta: '\x1b[35m',
      cyan: '\x1b[36m',
      white: '\x1b[37m',
      gray: '\x1b[90m',
    },
  },
}

// manually load config JSON (instead of importing it as a module) for future bundler compatibility
const config = JSON.parse(readFileSync('../config/config.json', 'utf-8'))

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

app.get('/mirror', (req, res) => {
  console.log(dbgRequestEndpoint(req))
  res.json(dbgRequestObject(req))
})

app.get('/mirror/:id', (req, res) => {
  console.log(dbgRequestEndpoint(req))
  res.json(dbgRequestObject(req))
})

app.post('/mirror', (req, res) => {
  console.log(dbgRequestEndpoint(req))
  res.json(dbgRequestObject(req))
})

app.listen(config.port, config.hostname, () => {
  console.log(
    `${ansiEscapes.colors.fg.green}server is now live on ${config.hostname}:${config.port}`,
    ansiEscapes.reset,
  )
})
