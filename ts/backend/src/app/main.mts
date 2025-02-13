import { loadConfig } from './features/config/config.mjs'
import { Logger } from './features/logger/logger.mjs'
import { Server } from './features/server/server.mjs'
import { AmpqService } from './features/services/ampq-service.mjs'
import { AuthService } from './features/services/auth-service.mjs'
import { SqlService } from './features/services/sql-service.mjs'
import { Schema } from './features/setup/schema.mjs'

const logger = new Logger('main')

const config = loadConfig()
// set up services first
SqlService.create(config)
AmpqService.create(config)
AuthService.create(config)

Schema.setup().then(() => {
  // once services are set up, start server
  new Server(config)
})

process.on('uncaughtException', (err: Error) => {
  logger.error('Uncaught exception', err.name, err.message, err.stack)
})
