import { appendDir } from '@common/endpoint-utils.js'
import { BenchmarkDefinitionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class BenchmarkController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/benchmarks', this.getBenchmarks)
    this.attachGet('/benchmarks/:id', this.getBenchmarkById)
  }

  getBenchmarks: GetHandler<'/benchmarks'> = async (req, res) => {
    const sql = SqlService.getInstance()
    const rows = await sql.query<StripDir<BenchmarkDefinitionRow>>`
      SELECT id, name, description, field_definition_ids, test_definition_ids FROM benchmark_definitions
      ORDER BY name ASC
    `
    const resources = appendDir('/benchmarks/', rows)
    this.respond(res, resources)
  }

  getBenchmarkById: GetHandler<'/benchmarks/:id'> = async (req, res) => {
    const ids = req.params.id.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<BenchmarkDefinitionRow>>`
      SELECT id, name, description, field_definition_ids, test_definition_ids FROM benchmark_definitions
      WHERE id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const benchmarks = appendDir('/benchmarks/', rows)
    this.respond(res, benchmarks)
  }
}
