import { appendDir } from '@common/endpoint-utils.js'
import { Test } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class TestController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/tests/:id', this.getTestById)
  }

  /**
   * @swagger
   * /tests/{ids}:
   *  get:
   *    description: Returns tests with ID in `ids`.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: ids
   *        description: Comma-separated list of IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: integer
   *    responses:
   *      200:
   *        description: Requested tests.
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: array
   *                      items:
   *                        type: object
   *                        properties:
   *                          dir:
   *                            type: string
   *                          id:
   *                            type: number
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   */
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
