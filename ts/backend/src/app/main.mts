import { parseCommandLine } from './features/config/command-line.mjs'
import { loadConfig } from './features/config/config.mjs'
import { Logger } from './features/logger/logger.mjs'
import { Server } from './features/server/server.mjs'
import { AmqpService } from './features/services/amqp-service.mjs'
import { AuthService } from './features/services/auth-service.mjs'
import { SqlService } from './features/services/sql-service.mjs'
import { Schema } from './features/setup/schema.mjs'

// during boot, use defaults for logger
Logger.setOptions({})

const logger = new Logger('main')

const options = parseCommandLine()

Logger.setOptions(options)

const config = loadConfig()
// set up services first
SqlService.create(config)
AmqpService.create(config)
AuthService.create(config)

Schema.setup().then(() => {
  // once services are set up, start server
  new Server(config)
})

process.on('uncaughtException', (err: Error) => {
  logger.error('Uncaught exception', err.name, err.message, err.stack)
})
