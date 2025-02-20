import ansiStyles from 'ansi-styles'
import wrapAnsi from 'wrap-ansi'
import { Logger } from '../logger/logger.mjs'

const PRETTY_PRINT_TERMINAL_WIDTH = process.stdout.columns
const PRETTY_PRINT_TITLE_WIDTH = 24

const logger = new Logger('cli')

export interface cliOptions {
  '--help'?: string
  '--log-level'?: string
  '--log-stack'?: string
  '--log-colorful'?: string
  '--log-stringify'?: string
}

// adhere to this and the manual writes itself
interface CommandLineArg {
  argument: keyof cliOptions
  alias?: string
  description: string
  type?: string
  default?: string
  // optional evaluator - default simply returns val
  evaluator?: (val?: string) => string | undefined
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
      return undefined
    },
  },
  {
    argument: '--log-level',
    description: 'Set log output level.',
    type: 'ALL | TRACE | DEBUG | INFO | WARN | ERROR | FATAL | OFF',
    default: 'INFO',
  },
  {
    argument: '--log-stack',
    description: 'Include logging source (method and file path) in log.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: (val) => (val === 'false' ? 'false' : 'true'),
  },
  {
    argument: '--log-colorful',
    description: 'Enable colorful terminal output for log.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: (val) => (val === 'false' ? 'false' : 'true'),
  },
  {
    argument: '--log-stringify',
    description: 'Output log messages as stringified JSON.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: (val) => (val === 'false' ? 'false' : 'true'),
  },
] as const

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
  const options: cliOptions = {}
  commandLineArgs.forEach((cla) => {
    let has = false
    let val: string | undefined
    // check for argument (full) first
    if (args.has(cla.argument)) {
      has = true
      val = args.get(cla.argument)
    }
    //... and only then check for alias. Otherwise de-duplicating could be circumvented.
    else if (cla.alias && args.has(cla.alias)) {
      has = true
      val = args.get(cla.alias)
    }
    if (has) {
      // evaluate
      if (cla.evaluator) {
        options[cla.argument] = cla.evaluator(val)
      } else {
        options[cla.argument] = val
      }
      // dispose
      args.delete(cla.argument)
      if (cla.alias) args.delete(cla.alias)
    }
  })
  // if args are left (undeleted) it means undefined args were given
  Array.from(args.keys()).forEach((key) => {
    logger.error('Invalid command line argument', key)
  })
  return options
}

function prettyPrintArgDef(def: Record<string, string>) {
  // minus 2 for the space between title and definition
  const maxTextWidth = Math.max(PRETTY_PRINT_TERMINAL_WIDTH - PRETTY_PRINT_TITLE_WIDTH - 2, 24)
  Object.entries(def).forEach(([key, value], idx) => {
    const textLines = wrapAnsi(value, maxTextWidth, { hard: true }).split('\n')
    // for first pair (argument), color title
    const colorStart = idx == 0 ? ansiStyles.color.blue.open : ''
    const colorEnd = idx == 0 ? ansiStyles.reset.close : ''
    // print property definition
    console.log(`${colorStart}${key.padStart(PRETTY_PRINT_TITLE_WIDTH)}${colorEnd}  ${textLines[0]}`)
    textLines.slice(1).forEach((line) => {
      console.log(`${' '.padStart(PRETTY_PRINT_TITLE_WIDTH)}  ${line}`)
    })
  })
  // terminate with blank line
  console.log()
}
