import ansiStyles from 'ansi-styles'
import { loadConfig } from './features/config/config.mjs'
import { Server } from './features/server/server.mjs'
import { AmpqService } from './features/services/ampq-service.mjs'
import { SqlService } from './features/services/sql-service.mjs'

const config = loadConfig()
// set up services first
new SqlService(config)
new AmpqService(config)
// once services are set up, start server
new Server(config)

process.on('uncaughtException', (err: Error) => {
  console.log(`${ansiStyles.red.open}Uncaught exception:${ansiStyles.reset.close}`)
  console.log(err)
})
