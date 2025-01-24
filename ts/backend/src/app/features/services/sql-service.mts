import postgres from 'postgres'
import { configuration } from '../config/config.mjs'
import { Service } from './service.mjs'

/**
 * Service class providing common SQL functionality.
 */
export class SqlService extends Service {
  /**
   * Postgres notices that occured during `query`. Is reset to `undefined`
   * upon invoking `query`.
   */
  notices?: postgres.Notice[]
  /**
   * Postgres errors that occured during `query`. Is reset to `undefined`
   * upon invoking `query`.
   */
  errors?: postgres.Error[]

  /**
   * Template tag to make SQL queries. All notices and errors raised during
   * query execution are written to {@link notices} and {@link errors}
   * respectively, which in turn are emptied at the start of `query`.
   * @example
   * ```ts
   * sqlService.query`DROP DATABASE benchmarks`
   * ```
   * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates | Tagged Templates}
   */
  query(
    strings: TemplateStringsArray,
    ...params: (number | string)[]
  ): Promise<postgres.RowList<postgres.Row[]> | never[]>
  query<T>(strings: TemplateStringsArray, ...params: (number | string)[]): Promise<T[]>

  query(strings: TemplateStringsArray, ...params: (number | string)[]) {
    this.notices = undefined
    this.errors = undefined
    return this._query(strings, params).catch((error) => {
      this.errors ??= []
      this.errors.push(error)
      return []
    })
  }

  private _query

  constructor(config: configuration) {
    super(config)

    this._query = postgres({
      host: this.config.postgres.host,
      port: this.config.postgres.port,
      user: this.config.postgres.user,
      password: this.config.postgres.password,
      database: this.config.postgres.database,
      // default onnotice console.logs, overwrite that to push to notices
      // notices is emptied upon query()
      onnotice: (notice) => {
        this.notices ??= []
        this.notices.push(notice)
      },
    })
  }

  /**
   * Sets up tables in database.
   * @returns query result
   */
  setup() {
    return this._query`
      CREATE TABLE submissions (
        id SERIAL PRIMARY KEY,
        submission_image VARCHAR(256) NOT NULL
      )
    `
  }
}
