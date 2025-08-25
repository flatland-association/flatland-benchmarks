import { dbgSqlState, SqlService } from '../../src/app/features/services/sql-service.mjs'
import { getTestConfig } from './setup.mjs'

describe.sequential('SQL Service (with Postgres)', () => {
  beforeAll(async () => {
    const testConfig = await getTestConfig()
    SqlService.create(testConfig)
  })

  test('should execute query `SELECT NOW()`', async () => {
    const sql = SqlService.getInstance()
    const rows = await sql.query`
      SELECT NOW()
    `
    expect(rows.at(0)?.['now']).toBeInstanceOf(Date)
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
    await expect(sql.query`
      SELEC
    `).rejects.toThrow()
  })

  test('should error on faulty query (schema error)', async () => {
    const sql = SqlService.getInstance()
    // Should this test ever fail maybe give the developer who decided to add a column named "shit emoji" to the benchmark table a stern talking-to.
    await expect(sql.query`
      SELECT 💩 FROM benchmarks
    `).rejects.toThrow()
  })

  test('should write notices to debug object', async () => {
    const sql = SqlService.getInstance()
    const rows = await sql.query`
      DROP TABLE IF EXISTS 🥳
    `
    const dbg = dbgSqlState(sql)
    expect(rows).toEqual([])
    expect(dbg.notices?.length).toBe(1)
    expect(dbg.notices?.at(0)?.['severity']).toBe('NOTICE')
    expect(dbg.notices?.at(0)?.['message']).toMatch('does not exist, skipping')
  })
})
