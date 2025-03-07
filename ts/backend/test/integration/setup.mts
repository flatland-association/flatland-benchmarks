import { DockerComposeEnvironment, StartedDockerComposeEnvironment } from 'testcontainers'
import { defaults } from '../../src/app/features/config/defaults.mjs'

/*
This global setup file is used to boot a Docker environment that runs in
parallel to the one used in development. To achieve that, take the dev env
and reconfigure ports and volumes, as they might conflict.
*/

const composeFilePath = '../../evaluation' // relative to ts/backend
const composeFile = 'docker-compose.yml'

// overwrite ports so test and dev environments can be up at the same time
process.env['RABBITMQ_MANAGEMENT_PORT'] = '35672'
process.env['RABBITMQ_PORT'] = '25672'
process.env['POSTGRES_PORT'] = '25432'
process.env['PGADMIN_LISTEN_PORT'] = '35432'
process.env['MINIO_PORT'] = '29000'
process.env['MINIO_CONSOLE_PORT'] = '29001'
process.env['REDIS_PORT'] = '26379'
process.env['KEYCLOAK_PORT'] = '28081'
// overwrite volumes
// TODO: test data should not be persistent, currently not possible as the volumes ar mounted
// https://github.com/flatland-association/flatland-benchmarks/issues/176
process.env['POSTGRES_VOLUME'] = './var/tmptest/postgres'
process.env['PGADMIN_VOLUME'] = './var/tmptest/pgadmin'
process.env['KEYCLOAK_VOLUME'] = './var/tmptest/keycloak'

const config = Object.assign({}, defaults)
config.api.port = 28000
config.postgres.port = 25432
config.amqp.port = 25672
// TODO: redis, keycloak: make port configurable directly
// depends on https://github.com/flatland-association/flatland-benchmarks/issues/52
config.keycloak.url.replace('6379', '26379')
config.keycloak.url.replace('8081', '28081')

export const testConfig = config

const DOCKER_COMPOSE_TIMEOUT = 5 * 60 * 1000 // ms

let environment: StartedDockerComposeEnvironment

// setup function - called by vitest once for test setup
export async function setup() {
  // bug in node 22.12.0, localhost dns lookup only gives IPv6 address.
  // manually provide IPv4
  // https://github.com/testcontainers/testcontainers-node/issues/818
  // https://github.com/nodejs/node/issues/56137
  process.env['TESTCONTAINERS_HOST_OVERRIDE'] = '127.0.0.1'
  environment = await new DockerComposeEnvironment(composeFilePath, composeFile)
    .withStartupTimeout(DOCKER_COMPOSE_TIMEOUT)
    .up()
}

// teardown function - called by vitest once for test teardown
export async function teardown() {
  await environment?.down()
}
