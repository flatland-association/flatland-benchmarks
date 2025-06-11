import { parseCommandLine } from './features/config/command-line.mjs'
import { loadConfig } from './features/config/config.mjs'
import { Logger } from './features/logger/logger.mjs'
import { Server } from './features/server/server.mjs'
import { CeleryService } from './features/services/celery-client-service.mjs'
import { AuthService } from './features/services/auth-service.mjs'
import { S3Service } from './features/services/s3-service.mjs'
import { SqlService } from './features/services/sql-service.mjs'

// during boot, use defaults for logger
Logger.setOptions({})

const logger = new Logger('main')

const options = parseCommandLine()

Logger.setOptions(options)

const config = loadConfig()
// set up services first
SqlService.create(config)
CeleryService.create(config)
AuthService.create(config)
S3Service.create(config)

new Server(config)

process.on('uncaughtException', (err: Error) => {
  logger.error('Uncaught exception', err.name, err.message, err.stack)
})
