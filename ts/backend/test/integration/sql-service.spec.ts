import { SqlService } from '../../src/app/features/services/sql-service.mjs'
import { Schema } from '../../src/app/features/setup/schema.mjs'
import { getTestConfig } from './setup.mjs'

const SETUP_TIMEOUT = 30 * 1000 // ms

describe.sequential('SQL Service (with Postgres)', () => {
  beforeAll(async () => {
    const testConfig = await getTestConfig()
    SqlService.create(testConfig)
  })

  test(
    'should be able to run Schema.setup()',
    async () => {
      await expect(Schema.setup()).resolves.toBeUndefined()
    },
    SETUP_TIMEOUT,
  )

  test('should execute query `SELECT NOW()`', async () => {
    const sql = SqlService.getInstance()
    const rows = await sql.query`
      SELECT NOW()
    `
    expect(rows.at(0)?.now).toBeInstanceOf(Date)
  })

  test('should execute query on set up schema', async () => {
    const sql = SqlService.getInstance()
    const rows = await sql.query`
      SELECT id FROM benchmarks
    `
    expect(rows).toEqual([{ id: 1 }])
  })

  test('should error on faulty query (syntax error)', async () => {
    const sql = SqlService.getInstance()
    const rows = await sql.query`
      SELEC
    `
    expect(rows).toEqual([])
    expect(sql.errors).toBeTruthy()
  })

  test('should error on faulty query (schema error)', async () => {
    const sql = SqlService.getInstance()
    // Should this test ever fail maybe give the developer who decided to add a column named "shit emoji" to the benchmark table a stern talking-to.
    const rows = await sql.query`
      SELECT 💩 FROM benchmarks
    `
    expect(rows).toEqual([])
    expect(sql.errors).toBeTruthy()
  })
})
