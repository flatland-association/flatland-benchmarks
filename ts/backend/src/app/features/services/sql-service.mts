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
   * Postgres statement from `query`. Is reset to `undefined` upon invoking
   * `query`.
   */
  statement?: postgres.Statement

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
    // TypeScript won't infer fragment type if not using `any`
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    ...params: postgres.ParameterOrFragment<any>[] // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ): Promise<postgres.RowList<postgres.Row[]> | any[]>
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  query<T>(strings: TemplateStringsArray, ...params: postgres.ParameterOrFragment<any>[]): Promise<T[]>

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  query(strings: TemplateStringsArray, ...params: postgres.ParameterOrFragment<any>[]) {
    this.notices = undefined
    this.errors = undefined
    this.statement = undefined
    return this._query(strings, ...params)
      .then((q) => {
        this.statement = q.statement
        return q
      })
      .catch((error) => {
        this.errors ??= []
        this.errors.push(error)
        return []
      })
  }

  private _query

  /**
   * Alias for the original postgres template tag for nested queries.
   */
  fragment

  constructor(config: configuration) {
    super(config)

    this._query = postgres({
      host: this.config.postgres.host,
      port: this.config.postgres.port,
      user: this.config.postgres.user,
      password: this.config.postgres.password,
      database: this.config.postgres.database,
      debug: true, // otherwise errors will be empty object
      // default onnotice console.logs, overwrite that to push to notices
      // notices is emptied upon query()
      onnotice: (notice) => {
        this.notices ??= []
        this.notices.push(notice)
      },
    })

    this.fragment = this._query
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

/**
 * Returns an object based off current SqlService state.
 * @param sql SqlService instance
 */
export function dbgSqlState(sql: SqlService) {
  return {
    notices: sql.notices,
    errors: sql.errors,
    statement: sql.statement,
  }
}
