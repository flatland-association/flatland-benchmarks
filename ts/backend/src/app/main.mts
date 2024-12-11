import ansiStyles from 'ansi-styles'
import { loadConfig } from './features/config/config.mjs'
import { Server } from './features/server/server.mjs'

const config = loadConfig()
new Server(config)

process.on('uncaughtException', (err: Error) => {
  console.log(`${ansiStyles.red.open}Uncaught exception:${ansiStyles.reset.close}`)
  console.log(err)
})
