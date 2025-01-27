import ansiStyles from 'ansi-styles'
import { loadConfig } from './features/config/config.mjs'
import { Server } from './features/server/server.mjs'
import { AmpqService } from './features/services/ampq-service.mjs'
import { SqlService } from './features/services/sql-service.mjs'
import { Schema } from './features/setup/schema.mjs'

const config = loadConfig()
// set up services first
SqlService.create(config)
AmpqService.create(config)

Schema.setup().then(() => {
  // once services are set up, start server
  new Server(config)
})

process.on('uncaughtException', (err: Error) => {
  console.log(`${ansiStyles.red.open}Uncaught exception:${ansiStyles.reset.close}`)
  console.log(err)
})
