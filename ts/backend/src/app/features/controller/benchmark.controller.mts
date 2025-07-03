import { appendDir } from '@common/endpoint-utils.js'
import { BenchmarkDefinitionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class BenchmarkController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/benchmarks', this.getBenchmarks)
    this.attachGet('/definitions/benchmarks/:id', this.getBenchmarkById)
  }

  /**
   * @swagger
   * /definitions/benchmarks/:
   *  get:
   *    description: Returns benchmarks.
   *    security:
   *      - oauth2: [user]
   *    responses:
   *      200:
   *        description: Benchmarks.
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
   *                          field_definition_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   */
  getBenchmarks: GetHandler<'/definitions/benchmarks'> = async (req, res) => {
    const sql = SqlService.getInstance()
    const rows = await sql.query<StripDir<BenchmarkDefinitionRow>>`
      SELECT id, name, description, field_definition_ids, test_ids FROM benchmark_definitions
      ORDER BY name ASC
    `
    const resources = appendDir('/definitions/benchmarks/', rows)
    this.respond(req, res, resources)
  }

  /**
   * @swagger
   * /definitions/benchmarks/{ids}:
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
   *            type: string
   *            format: uuid
   *    responses:
   *      200:
   *        description: Requested benchmarks.
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
   *                          field_definition_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   */
  getBenchmarkById: GetHandler<'/definitions/benchmarks/:id'> = async (req, res) => {
    const ids = req.params.id.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<BenchmarkDefinitionRow>>`
      SELECT id, name, description, field_definition_ids, test_ids FROM benchmark_definitions
      WHERE id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const benchmarks = appendDir('/definitions/benchmarks/', rows)
    this.respond(req, res, benchmarks)
  }
}
