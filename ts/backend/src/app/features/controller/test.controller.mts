import { appendDir } from '@common/endpoint-utils.mjs'
import { Test } from '@common/interfaces.mjs'
import { StripDir } from '@common/utility-types.mjs'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class TestController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/tests/:id', this.getTestById)
  }

  getTestById: GetHandler<'/tests/:id'> = async (req, res) => {
    const ids = req.params.id.split(',').map((s) => +s)
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<Test>>`
        SELECT * FROM tests
        WHERE id=ANY(${ids})
        LIMIT ${ids.length}
      `
    const tests = appendDir('/tests/', rows)
    // return array - dev.002
    this.respond(res, tests)
  }
}
