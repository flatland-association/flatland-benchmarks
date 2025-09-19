import { parse } from 'dotenv'
import type { ExecOptions } from 'node:child_process'
import { ChildProcess, exec } from 'node:child_process'
import fs from 'node:fs/promises'
import { request } from 'node:http'
import path from 'node:path'
import { clearTimeout } from 'node:timers'
import { DockerComposeEnvironment, StartedDockerComposeEnvironment } from 'testcontainers'
import treeKill from 'tree-kill'

// this script can be executed using
// node --experimental-strip-types ts/frontend/cypress/run-ci-press.mts

// change to script dir so it doesn't matter from where the script was executed
process.chdir(import.meta.dirname)

// attach shutdown handler for graceful termination
process.stdin.resume() // so the process doesn't exit early
process.on('SIGINT', () => shutdown())
process.on('SIGTERM', () => shutdown())
process.on('uncaughtException', (_error) => shutdown())

const composeFilePath = '../../../' // relative to ts/frontend/cypress
const composeFile = 'docker-compose.yml'
const envFile = '.env'
const DOCKER_COMPOSE_TIMEOUT = 1 * 60 * 1000 // ms

let docker: StartedDockerComposeEnvironment | undefined
let backend: ChildProcess | undefined
let frontend: ChildProcess | undefined
let cypress: ChildProcess | undefined

async function main() {
  console.log('-- | loading .env')
  const env = parse(await fs.readFile(path.join(composeFilePath, envFile), { encoding: 'utf8' }))

  console.log('-- | starting docker')
  docker = await new DockerComposeEnvironment(composeFilePath, composeFile)
    .withEnvironment(env)
    .withProfiles('tsdev')
    .withStartupTimeout(DOCKER_COMPOSE_TIMEOUT)
    .up()

  backend = myExec('npm run private:serve', 'BK', { cwd: '../../backend', env: { CUSTOMIZATION: 'ai4realnet' } })
  frontend = myExec('npm run private:serve', 'NG', { cwd: '..' })

  await waitFor('http://localhost:8000/health/live', 20000)
  await waitFor('http://localhost:4200', 20000)

  cypress = myExec('npm run cypress:run', 'CY', { cwd: '..' })

  cypress.on('exit', (code) => {
    cypress = undefined
    console.log(`-- | cypress terminated with exit code ${code}`)
    shutdown(code ?? 1)
  })
}

function myExec(command: string, ident: string, options: ExecOptions) {
  console.log(`-- | ${command}`)
  const process = exec(command, options)
  process.stderr?.setEncoding('utf-8')
  process.stderr?.on('data', (data: string) => {
    data
      .trimEnd()
      .replace('\r', '')
      .split('\n')
      .map((line) => line.trimEnd())
      .forEach((line) => {
        console.error(`${ident} | ${line}`)
      })
  })
  process.stdout?.setEncoding('utf8')
  process.stdout?.on('data', (data: string) => {
    data
      .trimEnd()
      .replace('\r', '')
      .split('\n')
      .map((line) => line.trimEnd())
      .forEach((line) => {
        console.log(`${ident} | ${line}`)
      })
  })
  return process
}

function waitFor(url: string, timeout = 60 * 1000): Promise<void> {
  return new Promise((resolve, reject) => {
    let cbRetry: NodeJS.Timeout
    const cbTimeout = setTimeout(() => {
      clearTimeout(cbRetry)
      reject()
    }, timeout)
    const doTry = async () => {
      console.log(`-- | pinging ${url}`)
      const status = await getHttpStatus(url).catch(() => undefined)
      console.log(`-- | ${url}: status ${status}`)
      if (status === 200) {
        clearTimeout(cbTimeout)
        resolve()
        return
      }
      // no success, try again later
      cbRetry = setTimeout(() => {
        doTry()
      }, 1000)
    }
    doTry()
  })
}

function getHttpStatus(url: string): Promise<number | undefined> {
  return new Promise((resolve, reject) => {
    const req = request(url, (res) => {
      resolve(res.statusCode)
    })
    req.on('error', (err) => {
      reject(err)
    })
    req.end()
  })
}

async function shutdown(code = 1) {
  if (cypress?.pid) {
    console.log('-- | terminating cypress')
    treeKill(cypress.pid)
  }
  if (frontend?.pid) {
    console.log('-- | terminating frontend')
    treeKill(frontend.pid)
  }
  if (backend?.pid) {
    console.log('-- | terminating backend')
    treeKill(backend.pid)
  }
  if (docker) {
    console.log('-- | terminating docker')
    await docker.down()
  }
  console.log(`-- | terminating with exit code ${code}`)
  process.exit(code)
}

main()
