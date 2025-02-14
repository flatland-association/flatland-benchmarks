import { json } from '@common/utility-types.mjs'
import ansiStyles from 'ansi-styles'

// Not using enum because of the JS TSC generates from enums. More info:
// https://www.typescriptlang.org/docs/handbook/enums.html
// https://www.totaltypescript.com/why-i-dont-like-typescript-enums
// numeric values based on https://stackoverflow.com/a/7751276/10135201
const LogLevelRaw = {
  OFF: 10_000_000,
  FATAL: 50_000,
  ERROR: 40_000,
  WARN: 30_000,
  INFO: 20_000,
  DEBUG: 10_000,
  TRACE: 5_000,
  ALL: 0,
} as const

/**
 * Available keys in `LogLevel`.
 * @see {@link LogLevel}
 */
export type LogLevelName = keyof typeof LogLevelRaw

/**
 * Numeric `LogLevel` values.
 * @see {@link LogLevel}
 */
export type LogLevelNumeric = (typeof LogLevelRaw)[LogLevelName]

/**
 * Available log levels.
 */
export const LogLevel = {
  ...LogLevelRaw,

  /**
   * Returns log level name.
   */
  name: (id: LogLevelNumeric): LogLevelName => {
    const names = Object.keys(LogLevelRaw) as LogLevelName[]
    return names.find((n) => LogLevelRaw[n] === id) ?? 'OFF'
  },
}

// The pattern (construct one logger per file instead of a service class) was
// chosen on purpose i.o.t. have logger available at boot already.
export class Logger {
  /** Default log level. Used if no instance specific log level is present. */
  static defaultLogLevel: LogLevelNumeric = LogLevel.INFO
  // these settings are global to ensure uniform log format while alive
  /** Whether to include the source of the log call. */
  static includeSource = false
  /** Whether to output the messages as one JSON array. */
  static jsonMessage = false
  /** Whether to use ANSI terminal colors in log. */
  static colorTerminal = false

  logLevel?: LogLevelNumeric
  category: string

  /**
   * Create a new logger instance.
   * @param category Logger category. Included in log.
   * @param level Optional log level override.
   */
  constructor(category = 'main', level?: LogLevelNumeric) {
    this.logLevel = level
    this.category = category
  }

  // Must be private i.o.t. always skip the correct number of stack trace lines.
  private log(level: LogLevelNumeric, ...messages: json[]) {
    // don't do anything if log level isn't active
    if (level < (this.logLevel ?? Logger.defaultLogLevel)) return
    // color and channel depending on level
    let dateColor = ansiStyles.color.gray.open
    let priorityColor = ansiStyles.color.gray.open
    let categoryColor = ansiStyles.color.blue.open
    let resetColor = ansiStyles.reset.close
    let channel = console.log
    switch (level) {
      case LogLevel.DEBUG:
        priorityColor = ansiStyles.color.white.open
        break
      case LogLevel.INFO:
        priorityColor = ansiStyles.color.green.open
        break
      case LogLevel.WARN:
        priorityColor = ansiStyles.color.yellow.open
        channel = console.error
        break
      case LogLevel.ERROR:
        priorityColor = ansiStyles.color.red.open
        channel = console.error
        break
      case LogLevel.FATAL:
        priorityColor = ansiStyles.color.magenta.open
        channel = console.error
    }
    if (!Logger.colorTerminal) {
      dateColor = ''
      priorityColor = ''
      categoryColor = ''
      resetColor = ''
    }

    const date = new Date().toISOString()
    const priority = LogLevel.name(level).padEnd(5)
    let source = ''
    if (Logger.includeSource) {
      // stack, beginning with 'Error', Logger.log and Logger.<calledMethod>
      const stack = new Error().stack!.split('\n')
      // relevant line of stack, either `at class.method (path/file:line:char)` or `at path/file:line:char`
      // - Attention: path separator can be / or \ !
      // - Can't build target class/method path if not present in stack, because some calls include internal node queue.
      // - Printing file:line:char is beneficial only if output is not minified.
      let src = stack[3].replace(/\s+at /, '')
      if (src.endsWith(')')) {
        src = src.replace(/\((.*)\)/, '$1')
      } else {
        src = '<anonymous> ' + src
      }
      source = ` (${src})`
    }
    const message = Logger.jsonMessage
      ? // with JSON message enabled, output all message bits as array
        JSON.stringify(messages)
      : // otherwise stringify only those necessary and separate by space
        messages
          .map((m) => {
            return typeof m === 'object' ? JSON.stringify(m) : m
          })
          .join(' ')

    // log pattern here
    const msg = `${dateColor}${date}${resetColor}${source} ${priorityColor}${priority}${resetColor} ${categoryColor}[${this.category}]${resetColor}: ${message}`
    channel(msg)
  }

  /**
   * Log a message with log level `TRACE`.
   */
  trace(...messages: json[]) {
    this.log(LogLevel.TRACE, ...messages)
  }

  /**
   * Log a message with log level `DEBUG`.
   */
  debug(...messages: json[]) {
    this.log(LogLevel.DEBUG, ...messages)
  }

  /**
   * Log a message with log level `INFO`.
   */
  info(...messages: json[]) {
    this.log(LogLevel.INFO, ...messages)
  }

  /**
   * Log a message with log level `WARN`.
   */
  warn(...messages: json[]) {
    this.log(LogLevel.WARN, ...messages)
  }

  /**
   * Log a message with log level `ERROR`.
   */
  error(...messages: json[]) {
    this.log(LogLevel.ERROR, ...messages)
  }

  /**
   * Log a message with log level `FATAL`.
   */
  fatal(...messages: json[]) {
    this.log(LogLevel.FATAL, ...messages)
  }
}
