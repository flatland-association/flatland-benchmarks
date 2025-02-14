import ansiStyles from 'ansi-styles'
import { Logger, LogLevel, LogLevelName } from '../logger/logger.mjs'
import { splitStringAt } from '../utils/split-string-at.mjs'

const PRETTY_PRINT_TERMINAL_WIDTH = process.stdout.columns
const PRETTY_PRINT_TITLE_WIDTH = 24

const logger = new Logger('cli')

// adhere to this and the manual writes itself
interface CommandLineArg {
  argument: string
  alias?: string
  description: string
  type?: string
  default?: string
  evaluator: (val?: string) => void
}

// known command line arguments - the order here defines order of evaluation
const commandLineArgs: CommandLineArg[] = [
  {
    argument: '--help',
    alias: '-h',
    description: 'Print this message.',
    evaluator: () => {
      // extract the argument manual from argument definition
      commandLineArgs.forEach((cla) => {
        let title = cla.argument
        if (cla.alias) title += ', ' + cla.alias
        prettyPrintArgDef({
          [title]: cla.description,
          ...(cla.type ? { type: cla.type } : {}),
          ...(cla.default ? { default: cla.default } : {}),
        })
      })
    },
  },
  {
    argument: '--log-level',
    description: 'Set log output level.',
    type: 'ALL | TRACE | DEBUG | INFO | WARN | ERROR | FATAL | OFF',
    default: 'INFO',
    evaluator: (val) => {
      const level = val ? LogLevel[val as LogLevelName] : undefined
      if (typeof level != 'undefined') {
        Logger.defaultLogLevel = level
      } else {
        logger.error('Invalid log level', val)
      }
    },
  },
  {
    argument: '--log-source',
    description: 'Include logging source (method and file path) in log.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: (val) => {
      if (val !== 'false') {
        Logger.includeSource = true
      }
    },
  },
  {
    argument: '--log-colorful',
    description: 'Enable colorful terminal output for log.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: (val) => {
      if (val !== 'false') {
        Logger.colorTerminal = true
      }
    },
  },
  {
    argument: '--log-json',
    description: 'Output log messages as valid JSON only.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: (val) => {
      if (val !== 'false') {
        Logger.jsonMessage = true
      }
    },
  },
]

// read command line arguments and pass them to their respective evaluators
export function parseCommandLine() {
  // turn into map first i.o.t. remove duplicates and let the order be defined
  // by consumer (that is, this file)
  const args = new Map(
    process.argv.slice(2).map((arg) => {
      const [key, value] = arg.split('=')
      return [key, value] as const
    }),
  )
  commandLineArgs.forEach((cla) => {
    // check for argument (full) first
    if (args.has(cla.argument)) {
      cla.evaluator(args.get(cla.argument))
      args.delete(cla.argument)
    }
    //... and only then check for alias. Otherwise de-duplicating could be circumvented.
    else if (cla.alias && args.has(cla.alias)) {
      cla.evaluator(args.get(cla.alias))
      args.delete(cla.alias)
    }
  })
  // if args are left (undeleted) it means undefined args were given
  Array.from(args.keys()).forEach((key) => {
    logger.error('Invalid command line argument', key)
  })
}

function prettyPrintArgDef(def: Record<string, string>) {
  // minus 2 for the space between title and definition
  const maxTextWidth = Math.max(PRETTY_PRINT_TERMINAL_WIDTH - PRETTY_PRINT_TITLE_WIDTH - 2, 24)
  Object.entries(def).forEach(([key, value], idx) => {
    const textLines: string[] = []
    value = value.trim()
    while (value.length > maxTextWidth) {
      // look for breakable char before max text width
      let wrapPos = maxTextWidth
      for (let i = 0; i < maxTextWidth; i++) {
        const pos = maxTextWidth - i - 1
        const char = value[pos]
        // char is one of the breakable ones
        if (' .,:;-'.includes(char)) {
          wrapPos = pos
          break
        }
      }
      // split string and remove unnecessary white space
      const splat = splitStringAt(value, wrapPos)
      textLines.push(splat[0].trimEnd())
      value = splat[1].trimStart()
    }
    // append rest of value as-is
    textLines.push(value)
    // for first pair (argument), color title
    const colorStart = idx == 0 ? ansiStyles.color.blue.open : ''
    const colorEnd = idx == 0 ? ansiStyles.reset.close : ''
    // print property definition
    console.log(`${colorStart}${key.padStart(PRETTY_PRINT_TITLE_WIDTH)}${colorEnd}  ${textLines[0]}`)
    textLines.slice(1, -1).forEach((line) => {
      console.log(`${' '.padStart(PRETTY_PRINT_TITLE_WIDTH)}  ${line}`)
    })
  })
  // terminate with blank line
  console.log()
}
