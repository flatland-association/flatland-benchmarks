import { beforeAll, describe, expect, it } from 'vitest'
import { loadConfig } from '../config/config.mjs'
import { SqlService } from './sql-service.mjs'

describe('SQL Service', () => {
  beforeAll(() => {
    const config = loadConfig()

    // All tests in this unit test test the services error behavior.
    // To enforce that, set an unreachable port.
    config.postgres.host = 'nix.com'
    config.postgres.port = 1 // do not use 0 - would fall back to default

    SqlService.create(config)
  })

  it('is instantiated despite faulty config', () => {
    const sql = SqlService.getInstance()
    expect(sql).toBeTruthy()
  })

  it('aborts and throws error on error', async () => {
    const sql = SqlService.getInstance()
    await expect(async () => {
      await sql.query`SELECT * FROM field_definitions`
    }).rejects.toThrow()
  })
})
