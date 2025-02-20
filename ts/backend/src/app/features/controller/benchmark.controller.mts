import { appendDir } from '@common/endpoint-utils.mjs'
import { Benchmark, BenchmarkPreview } from '@common/interfaces.mjs'
import { StripDir } from '@common/utility-types.mjs'
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
    const rows = await sql.query<StripDir<BenchmarkPreview>>`
      SELECT id, name, description FROM benchmarks
      ORDER BY id ASC
    `
    const resources = appendDir('/benchmarks/', rows)
    this.respond(res, resources)
  }

  getBenchmarkById: GetHandler<'/benchmarks/:id'> = async (req, res) => {
    const ids = req.params.id.split(',').map((s) => +s)
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<Benchmark>>`
      SELECT * FROM benchmarks
      WHERE id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const benchmarks = appendDir('/benchmarks/', rows)
    this.respond(res, benchmarks)
  }
}
