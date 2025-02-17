import { beforeAll, describe, expect, it } from 'vitest'
import { loadConfig } from '../config/config.mjs'
import { SqlService } from './sql-service.mjs'

describe('SQL Service', () => {
  beforeAll(() => {
    const config = loadConfig()

    // All tests in this unit test test the services error behavior.
    // To enforce that, set an unreachable port.
    config.postgres.port = 1 // do not use 0 - would fall back to default

    SqlService.create(config)
  })

  it('SqlService is instantiated despite faulty config', () => {
    const sql = SqlService.getInstance()
    expect(sql).toBeTruthy()
  })

  it('Does not abort query or throw error, writes to errors instead', async () => {
    const sql = SqlService.getInstance()
    expect(sql.errors).toBeUndefined()
    const rows = await sql.query`SELECT * FROM tests`
    expect(rows).toEqual([])
    expect(sql.errors).not.toEqual([])
  })
})
