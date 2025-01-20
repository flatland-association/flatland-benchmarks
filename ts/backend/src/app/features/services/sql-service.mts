import postgres from 'postgres'
import { configuration } from '../config/config.mjs'

const instances = new Map<string, SqlService>()

/**
 * Service class providing common SQL functionality.
 */
export class SqlService {
  // default is always available
  /**
   * Returns a previously constructed instance of `SqlService`.
   * @returns Default `SqlService` instance.
   */
  static getInstance(): SqlService

  //... others might not necessarily be
  /**
   * Returns a previously constructed instance of `SqlService`.
   * @param ident Instance identifier.
   * @returns A `SqlService` instance or `undefined` when an un-constructed instance was requested.
   */
  static getInstance(ident: string): SqlService | undefined

  static getInstance(ident = 'default') {
    return instances.get(ident)
  }

  /**
   * Template tag to make SQL queries.
   * @example
   * ```ts
   * sqlService.query`DROP DATABASE benchmarks`
   * ```
   * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates | Tagged Templates}
   */
  query

  constructor(
    public config: configuration,
    ident = 'default',
  ) {
    instances.set(ident, this)

    this.query = postgres({
      host: config.postgres.host,
      port: config.postgres.port,
      user: config.postgres.user,
      password: config.postgres.password,
      database: config.postgres.database,
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
