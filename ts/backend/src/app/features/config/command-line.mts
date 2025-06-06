import ansiStyles from 'ansi-styles'
import wrapAnsi from 'wrap-ansi'
import { Logger } from '../logger/logger.mjs'

/* 
This file provides:
A) A unified way to define CLI options together with their shorthand aliases
and description. It will also generate the output for the --help option from
these definitions.
B) A function that parses the process argvs into a workable object.
*/

const PRETTY_PRINT_TERMINAL_WIDTH = process.stdout.columns
const PRETTY_PRINT_TITLE_WIDTH = 24

const logger = new Logger('cli')

/**
 * Interface of the object returned by `parseCommandLine`.
 * All known command line options/arguments have to be declared here first.
 * Their definitions are then listed in commandLineArgs.
 * @see {@link parseCommandLine}
 */
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

/**
 * Evaluates `'false'` as `false` and anything else (including no value) as
 * `true` - used for boolean flags.
 */
export const flagEvaluator = (val?: string) => (val === 'false' ? 'false' : 'true')

// known command line arguments
export const commandLineArgs: CommandLineArg[] = [
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
    evaluator: flagEvaluator,
  },
  {
    argument: '--log-colorful',
    description: 'Enable colorful terminal output for log.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: flagEvaluator,
  },
  {
    argument: '--log-stringify',
    description: 'Output log messages as stringified JSON.',
    type: 'false | <any other value>',
    default: 'false',
    evaluator: flagEvaluator,
  },
] as const

// read command line arguments and pass them to their respective evaluators
/**
 * Reads the command line arguments, passes them through their respective
 * evaluators and writes the value to the returned options object.
 * @returns an object of `cliOptions`
 * @see {@link cliOptions}
 */
export function parseCommandLine() {
  const options: cliOptions = {}
  const parsedArguments = new Set<string>()
  // skip first two argvs - these are working dir and entry file
  process.argv.slice(2).forEach((arg) => {
    const { 0: key, 1: value } = arg.split('=')
    // find matching arg definition
    const cla = commandLineArgs.find((cla) => key === cla.argument || key === cla.alias)
    // evaluate valid arguments
    if (cla) {
      // apply/evaluate first occurrence only
      if (!parsedArguments.has(cla.argument)) {
        parsedArguments.add(cla.argument)
        if (cla.evaluator) {
          options[cla.argument] = cla.evaluator(value)
        } else {
          options[cla.argument] = value
        }
      }
      // report duplicates
      else {
        logger.warn('Duplicate command line argument', key)
      }
    }
    // report invalid arguments
    else {
      logger.error('Invalid command line argument', key)
    }
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
