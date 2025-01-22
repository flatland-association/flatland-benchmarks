import ansiStyles from 'ansi-styles'
import { SqlService } from '../services/sql-service.mjs'

// TODO: Consider making this a service that auto-boots.

export class Schema {
  static sql: SqlService

  /**
   * Sets up database schema.
   */
  static async setup(this: typeof Schema) {
    this.sql = SqlService.getInstance()

    // create/migrate tables sequentially

    await this.migrate('TABLE SCHEMA benchmarks v1')`
      CREATE TABLE IF NOT EXISTS benchmarks (
        id SERIAL PRIMARY KEY,
        title VARCHAR(256) NOT NULL,
        description TEXT NOT NULL,
        docker_image VARCHAR(256) NOT NULL
      )
    `

    await this.migrate('TABLE VALUES benchmarks v1')`
      INSERT INTO benchmarks
        (id, title, description, docker_image)
      VALUES
        (1, 'Flatland 3', 'The Flatland 3 Challenge is the newest competition around the Flatland environment.', 'ghcr.io/flatland-association/fab-flatland-evaluator:latest')
      ON CONFLICT (id)
        DO NOTHING
    `

    await this.migrate('TABLE SCHEMA submissions v1')`
      CREATE TABLE IF NOT EXISTS submissions (
        id SERIAL PRIMARY KEY,
        submission_image VARCHAR(256) NOT NULL
      )
    `
  }

  /**
   * Pretty prints what is going on and executes the attached SQL query.
   * @returns Template tag for query.
   * @see {@link SqlService.query}
   */
  private static migrate(label: string) {
    const text = `Migrating ${label}`
    return async (strings: TemplateStringsArray, ...params: string[]) => {
      this.log('busy', text)
      // assume result will always be empty and can be ignored
      await this.sql.query(strings, ...params)
      this.log(this.sql.errors ? 'error' : 'ok', text)
      if (this.sql.errors) {
        const [error] = this.sql.errors[0].message.split('\n')
        console.log(error)
      }
    }
  }

  /**
   * Outputs text with status indicator. Must always be ultimately used with
   * `'ok'` or `'error'` i.o.t. proceed (line feed).
   */
  private static log(indicate: 'busy' | 'ok' | 'error', text: string) {
    if (indicate === 'busy') {
      // while busy, don't feed line
      process.stdout.write(`${ansiStyles.blue.open}…${ansiStyles.reset.close} ${text}\r`)
    } else if (indicate === 'ok') {
      process.stdout.write(`${ansiStyles.green.open}✓${ansiStyles.reset.close} ${text}\n`)
    } else {
      process.stdout.write(`${ansiStyles.red.open}✗${ansiStyles.reset.close} ${text}\n`)
    }
  }
}
