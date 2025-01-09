import styles from 'ansi-styles'
import JSON5 from 'json5'
import fs from 'node:fs'
import path from 'node:path'
import { defaults } from './defaults.mjs'

export type configuration = typeof defaults

const VERBOSE = false

// go through all keys in defaults and copy over values
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function applyDefaults(object: any, defaults: any, path = '') {
  for (const key in defaults) {
    if (VERBOSE) {
      console.log(`${styles.gray.open}checking configuration for ${path}${key}${styles.reset.close}`)
    }
    // copy missing fields from defaults
    if (!Object.prototype.hasOwnProperty.call(object, key)) {
      // always deep-copy defaults, prevents changing defaults object via changing loaded config
      const defs = JSON.parse(JSON.stringify(defaults[key]))
      object[key] = defs
      // console.warn does not seem to automatically color the output
      console.warn(`${styles.yellow.open}Using defaults for ${path}${key}:${styles.reset.close}`, defs)
    }
    // if both are existing objects, go deeper
    else if (typeof object[key] === 'object' && typeof defaults[key] === 'object') {
      applyDefaults(object[key], defaults[key], `${key}.`)
    }
  }
}

export function loadConfig(): configuration {
  const confPath = path.join('../config/config.jsonc')

  let loadedConfig: Partial<configuration> = {}

  if (fs.existsSync(confPath)) {
    loadedConfig = JSON5.parse<configuration>(fs.readFileSync(confPath, 'utf-8'))
  } else {
    console.warn(`${styles.yellow.open}No configuration file found under ${confPath}${styles.reset.close}`)
  }

  applyDefaults(loadedConfig, defaults)

  return loadedConfig as configuration
}
