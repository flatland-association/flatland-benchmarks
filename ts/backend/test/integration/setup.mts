import { parse } from 'dotenv'
import JSON5 from 'json5'
import fs from 'node:fs/promises'
import path from 'node:path'
import { DockerComposeEnvironment, StartedDockerComposeEnvironment } from 'testcontainers'
import { defaults } from '../../src/app/features/config/defaults.mjs'

/*
This global setup file is used to boot a Docker environment that runs in
parallel to the one used in development. To achieve that, take the dev env
and reconfigure ports and volumes, as they might conflict.
*/

const composeFilePath = '../../' // relative to ts/backend
const composeFile = 'docker-compose.yml'
const envFile = '.env'
const envTestFile = '.env.test'

const DOCKER_COMPOSE_TIMEOUT = 1 * 60 * 1000 // ms

let environment: StartedDockerComposeEnvironment

// setup function - called by vitest once for test setup
export async function setup() {
  const env = await loadEnv()

  environment = await new DockerComposeEnvironment(composeFilePath, composeFile)
    .withEnvironment(env)
    .withStartupTimeout(DOCKER_COMPOSE_TIMEOUT)
    .up()
}

// teardown function - called by vitest once for test teardown
export async function teardown() {
  await environment?.down()
}

// returns the default config with tweaks for testing
export async function getTestConfig() {
  // Tests and setup run in separate threads and there's no handy way to
  // populate the env globally, hence it has to be loaded every time the config
  // needs to be built.
  const env = await loadEnv()

  // deep copy using JSON to prevent side effects between tests
  const testConfig = JSON5.parse(JSON5.stringify(defaults))

  // adjust testConfig with ports from env
  // (the test runs outside testcontainers, so the services must connect to the
  // forwarded ports)
  testConfig.postgres.port = +env['POSTGRES_PORT']
  testConfig.amqp.port = +env['RABBITMQ_PORT']
  // TODO: redis, keycloak: make port configurable directly
  // depends on https://github.com/flatland-association/flatland-benchmarks/issues/52
  testConfig.keycloak.url = testConfig.keycloak.url.replace('8081', env['KEYCLOAK_PORT'])

  return testConfig
}

// returns .env merged with .env.test
async function loadEnv() {
  // load the .env files
  const envBase = parse(await fs.readFile(path.join(composeFilePath, envFile), { encoding: 'utf8' }))
  const envTest = parse(await fs.readFile(path.join(composeFilePath, envTestFile), { encoding: 'utf8' }))
  //... and merge them
  return Object.assign(envBase, envTest)
}
