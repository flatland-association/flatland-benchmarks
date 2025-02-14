import { json } from '@common/utility-types.mjs'
import ansiStyles from 'ansi-styles'
import log4js from 'log4js'
import { cliOptions } from '../config/command-line.mjs'

// The pattern (construct one logger per file instead of a service class) was
// chosen on purpose i.o.t. have logger available at boot already.
export class Logger {
  /** Default log level. Used if no instance specific log level is present. */
  static defaultLogLevel: log4js.Level
  // these settings are global to ensure uniform log format while alive
  /** Whether to include the source of the log call. */
  static includeStack = false
  /** Whether to output the messages as one JSON array. */
  static stringifyMessage = false
  /** Whether to use ANSI terminal colors in log. */
  static colorTerminal = false

  static setOptions(options: cliOptions) {
    // store cli options
    this.defaultLogLevel = log4js.levels.getLevel(options['--log-level'] ?? 'INFO')
    this.includeStack = options['--log-stack'] === 'true'
    this.stringifyMessage = options['--log-stringify'] === 'true'
    this.colorTerminal = options['--log-colorful'] === 'true'

    // build pattern
    // stack is optional
    const stackPattern = this.includeStack ? ' (%X{stack})' : ''
    // colors are optional
    const datePattern = this.colorTerminal ? `${ansiStyles.gray.open}%d${ansiStyles.reset.close}` : '%d'
    const prioPattern = this.colorTerminal ? '%[%-5p%]' : '%-5p'
    const categoryPattern = this.colorTerminal ? `${ansiStyles.blue.open}[%c]${ansiStyles.reset.close}` : '[%c]'

    const pattern = `${datePattern}${stackPattern} ${prioPattern} ${categoryPattern}: %m`

    // drop previous configuration if there's one
    if (log4js.isConfigured()) {
      log4js.shutdown()
    }
    log4js.configure({
      // https://log4js-node.github.io/log4js-node/appenders.html
      // https://log4js-node.github.io/log4js-node/logLevelFilter.html
      appenders: {
        out: { type: 'stdout', layout: { type: 'pattern', pattern: pattern } },
      },
      // https://log4js-node.github.io/log4js-node/categories.html
      categories: {
        default: { appenders: ['out'], level: 'all' },
      },
      levels: {
        // overwrite trace default (color)
        TRACE: {
          value: log4js.levels.TRACE.level,
          colour: 'grey', //... author chose to go with British English
        },
      },
    })
  }

  private logger
  logLevel?: log4js.Level

  /**
   * Create a new logger instance.
   * @param category Logger category. Included in log.
   * @param level Optional log level override.
   */
  constructor(category = 'main', level?: log4js.Level) {
    this.logger = log4js.getLogger(category)
    this.logLevel = level
  }

  // Must be private i.o.t. always skip the correct number of stack trace lines.
  private log(level: log4js.Level, ...messages: json[]) {
    // update log level (can't be done in constructor because level is set at runtime)
    this.logger.level = this.logLevel ?? Logger.defaultLogLevel

    // log4js' default call stack parser seems to struggle in some cases with
    // anonymous functions.
    // Instead of using a custom parser, create the callstack here (where the
    // stack level won't change) and pass it to the logger as context.
    if (Logger.includeStack) {
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
      this.logger.addContext('stack', src)
    }

    this.logger.log(level, Logger.stringifyMessage ? JSON.stringify(messages) : messages)

    return
  }

  /**
   * Log a message with log level `TRACE`.
   */
  trace(...messages: json[]) {
    this.log(log4js.levels.TRACE, ...messages)
  }

  /**
   * Log a message with log level `DEBUG`.
   */
  debug(...messages: json[]) {
    this.log(log4js.levels.DEBUG, ...messages)
  }

  /**
   * Log a message with log level `INFO`.
   */
  info(...messages: json[]) {
    this.log(log4js.levels.INFO, ...messages)
  }

  /**
   * Log a message with log level `WARN`.
   */
  warn(...messages: json[]) {
    this.log(log4js.levels.WARN, ...messages)
  }

  /**
   * Log a message with log level `ERROR`.
   */
  error(...messages: json[]) {
    this.log(log4js.levels.ERROR, ...messages)
  }

  /**
   * Log a message with log level `FATAL`.
   */
  fatal(...messages: json[]) {
    this.log(log4js.levels.FATAL, ...messages)
  }
}
