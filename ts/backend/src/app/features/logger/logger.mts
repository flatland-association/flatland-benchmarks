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
    // (including line:char is beneficial only if output is not minified.)
    // (log4js' stack patterns - %s, %C etc - yield inconsistent values, use
    // custom stack pattern instead. See comment in `log` for more info.)
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
  private log(level: log4js.Level, ...messages: unknown[]) {
    // update log level (can't be done in constructor because level is set at runtime)
    this.logger.level = this.logLevel ?? Logger.defaultLogLevel

    // Node's error stack omits '<anonymous>' for awaited code or async
    // anonymous functions (same behavior in log4js default call stack parser).
    // To achieve a consistent log format, add '<anonymous>' where missing.
    // There are two ways to provide a custom call stack parser to do that:
    // - setParseCallStackFunction on the logger instance
    // - parse call stack here and pass output as context to logger instance
    // I chose latter, because in that case the call stack overhead is known
    // a priori (see below).
    if (Logger.includeStack) {
      // Stack, beginning with 'Error', Logger.log and Logger.<calledMethod>,
      // followed by the relevant line.
      // Relevant line of stack, either formatted
      // - ` at Class.method (file:line:char)` [format A] or
      // - ` at file:line:char` [format B]
      const stackLine = new Error().stack!.split('\n')[3]
      // Note: Don't try to derive the true source Class.method name if not
      // present in relevant line - call stack may include internal node queue
      // and filtering this is out of scope. Just use <anonymous> instead.
      // remove leading whitespace and 'at '
      let src = stackLine.replace(/\s+at /, '')
      // unify format A and B
      // trailing ')' = format A
      if (src.endsWith(')')) {
        //... free file:line:char from brackets
        src = src.replace(/\((.*)\)/, '$1')
      } else {
        //... prepend pseudo method name
        src = '<anonymous> ' + src
      }
      this.logger.addContext('stack', src)
    }

    let printables: unknown[] | string
    if (Logger.stringifyMessage) {
      // some types require special treatment in order to be stringified correctly
      printables = JSON.stringify(
        messages.map((msg) => {
          // functions are JSON.stringified as undefined
          if (typeof msg === 'function') {
            return msg.toString()
          }
          // symbols are JSON.stringified as undefined
          if (typeof msg === 'symbol') {
            return msg.toString()
          }
          // bigints cause error in JSON.stringify
          if (typeof msg === 'bigint') {
            return `BigInt(${msg})`
          }
          // undefined is JSON.stringified as null - make distinguishable
          if (typeof msg === 'undefined') {
            return 'null(undefined)'
          }
          // errors are JSON.stringified as {}
          if (msg instanceof Error) {
            let stringified = msg.toString()
            if (msg.stack) {
              stringified += ' (' + msg.stack + ')'
            }
            return stringified
          }
          return msg
        }),
      )
    } else {
      printables = messages.map((msg) => {
        // functions are not preserved in node when written to stdout
        if (typeof msg === 'function') {
          return msg.toString()
        }
        return msg
      })
    }
    this.logger.log(level, printables)

    return
  }

  /**
   * Log a message with log level `TRACE`.
   */
  trace(...messages: unknown[]) {
    this.log(log4js.levels.TRACE, ...messages)
  }

  /**
   * Log a message with log level `DEBUG`.
   */
  debug(...messages: unknown[]) {
    this.log(log4js.levels.DEBUG, ...messages)
  }

  /**
   * Log a message with log level `INFO`.
   */
  info(...messages: unknown[]) {
    this.log(log4js.levels.INFO, ...messages)
  }

  /**
   * Log a message with log level `WARN`.
   */
  warn(...messages: unknown[]) {
    this.log(log4js.levels.WARN, ...messages)
  }

  /**
   * Log a message with log level `ERROR`.
   */
  error(...messages: unknown[]) {
    this.log(log4js.levels.ERROR, ...messages)
  }

  /**
   * Log a message with log level `FATAL`.
   */
  fatal(...messages: unknown[]) {
    this.log(log4js.levels.FATAL, ...messages)
  }
}
