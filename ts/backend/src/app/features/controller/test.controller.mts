import { TestDefinitionRow } from '@common/interfaces.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class TestController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/tests/:test_ids', this.getTestById)
  }

  /**
   * @swagger
   * /definitions/tests/{test_ids}:
   *  get:
   *    description: Returns tests with ID in `ids`.
   *    parameters:
   *      - in: path
   *        name: test_ids
   *        description: Comma-separated list of IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
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
   *                          id:
   *                            type: string
   *                            format: uuid
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          scenario_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   */
  getTestById: GetHandler<'/definitions/tests/:test_ids'> = async (req, res) => {
    const ids = req.params.test_ids.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const tests = await sql.query<TestDefinitionRow>`
        SELECT * FROM test_definitions
        WHERE id=ANY(${ids})
        LIMIT ${ids.length}
      `
    // return array - dev.002
    this.respond(req, res, tests)
  }
}
