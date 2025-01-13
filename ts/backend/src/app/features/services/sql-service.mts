import postgres from 'postgres'
import { configuration } from '../config/config.mjs'

const instances = new Map<string, SqlService>()

export class SqlService {
  static getInstance(ident = 'default') {
    return instances.get(ident)
  }

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
