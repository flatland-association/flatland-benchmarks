import postgres from 'postgres'
import { configuration } from '../config/config.mjs'
import { Service } from './service.mjs'

/**
 * Interface wrapping postgres' sql template tag in `query`, which is itself
 * also a template tag, but returns the resulting rows.
 */
export interface WrappedSql {
  // must extends object | undefined otherwise it's not usable in RowList
  /**
   * Template tag to make SQL queries. Side effects depend on implementation.
   * @throws postgres.Error
   * @example
   * ```ts
   * sql.query`DROP DATABASE benchmarks`
   * ```
   * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates | Tagged Templates}
   */
  query<T extends object | undefined>(
    strings: TemplateStringsArray,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    ...params: postgres.ParameterOrFragment<any>[]
  ): Promise<postgres.RowList<T[]>>
  fragment: postgres.TransactionSql
}

/**
 * Service class providing common SQL functionality.
 */
export class SqlService extends Service {
  /**
   * Postgres notices that occurred during `query`. Is reset to `undefined`
   * upon invoking `query` or `transaction`.
   */
  notices?: postgres.Notice[]

  /**
   * Postgres statements from `query`. Is reset to `undefined` upon invoking
   * `query` or `transaction`.
   */
  statements?: postgres.Statement[]

  /**
   * Template tag to make SQL queries. All notices raised during query execution
   * are written to {@link notices}, which in turn are emptied at the start of
   * `query`.
   * @throws postgres.Error
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
    this.statements = undefined
    return this._query(strings, ...params).then((q) => {
      this.statements ??= []
      this.statements.push(q.statement)
      return q
    })
  }

  private _query

  /**
   * Alias for the original postgres template tag for nested queries.
   */
  fragment

  /**
   * Begins a transaction. The transaction queries are executed in the callback.
   * The use of `sql.query` within the callback won't reset {@link notices} or
   * {@link statements} for debugging purposes.
   * @param transactions Callback with a WrappedSql object for this transaction.
   * @example
   * ```ts
   * // The re-use of `sql` is intentional - prevents accidentally accessing
   * // parent sql from within transaction.
   * await sql.transaction(async (sql) => {
   *   await sql.query`INSERT INTO results ${sql.fragment(results)}`
   * })
   * ```
   */
  async transaction(transactions: (sql: WrappedSql) => Promise<unknown>) {
    this.notices = undefined
    this.statements = undefined
    await this._query.begin(async (postgresql) => {
      const wrappedSql: WrappedSql = {
        query: <T extends object | undefined>(
          strings: TemplateStringsArray,
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          ...params: postgres.ParameterOrFragment<any>[]
        ) => {
          const query = postgresql<T[]>(strings, ...params).then((q) => {
            this.statements ??= []
            this.statements.push(q.statement)
            return q
          })
          return query
        },
        fragment: postgresql,
      }
      await transactions(wrappedSql)
    })
  }

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
}

/**
 * Returns an object based off current SqlService state.
 * @param sql SqlService instance
 */
export function dbgSqlState(sql: SqlService) {
  return {
    notices: sql.notices,
    statement: sql.statements,
  }
}
