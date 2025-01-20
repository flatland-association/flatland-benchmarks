import postgres from 'postgres'
import { configuration } from '../config/config.mjs'
import { Service } from './service.mjs'

/**
 * Service class providing common SQL functionality.
 */
export class SqlService extends Service {
  /**
   * Template tag to make SQL queries.
   * @example
   * ```ts
   * sqlService.query`DROP DATABASE benchmarks`
   * ```
   * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates | Tagged Templates}
   */
  query

  constructor(config: configuration) {
    super(config)

    this.query = postgres({
      host: this.config.postgres.host,
      port: this.config.postgres.port,
      user: this.config.postgres.user,
      password: this.config.postgres.password,
      database: this.config.postgres.database,
    })
  }

  /**
   * Sets up tables in database.
   * @returns query result
   */
  setup() {
    return this.query`
      CREATE TABLE submissions (
        id SERIAL PRIMARY KEY,
        submission_image VARCHAR(256) NOT NULL
      )
    `
  }
}
