import { BenchmarkDefinitionRow } from '@common/interfaces.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class BenchmarkController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/benchmarks', this.getBenchmarks)
    this.attachGet('/definitions/benchmarks/:benchmark_ids', this.getBenchmarkById)
  }

  /**
   * @swagger
   * /definitions/benchmarks/:
   *  get:
   *    description: Returns benchmarks.
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
   *                          contents:
   *                            type: object
   *                            description: Additional textual contents for page.
   *                          field_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          suite_id:
   *                            type: string
   *                            format: uuid
   */
  getBenchmarks: GetHandler<'/definitions/benchmarks'> = async (req, res) => {
    const sql = SqlService.getInstance()
    const benchmarks = await sql.query<BenchmarkDefinitionRow>`
      SELECT benchmarks.id, benchmarks.name, benchmarks.description, benchmarks.contents, benchmarks.field_ids, benchmarks.campaign_field_ids, benchmarks.test_ids, suites.id as suite_id FROM benchmarks
      LEFT JOIN suites ON benchmarks.id=ANY(suites.benchmark_ids)
      ORDER BY name ASC
    `
    this.respond(req, res, benchmarks)
  }

  /**
   * @swagger
   * /definitions/benchmarks/{benchmark_ids}:
   *  get:
   *    description: Returns tests with ID in `ids`.
   *    parameters:
   *      - in: path
   *        name: benchmark_ids
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
   *                          contents:
   *                            type: object
   *                            description: Additional textual contents for page.
   *                          field_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          test_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   *                          suite_id:
   *                            type: string
   *                            format: uuid
   */
  getBenchmarkById: GetHandler<'/definitions/benchmarks/:benchmark_ids'> = async (req, res) => {
    const ids = req.params.benchmark_ids.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const benchmarks = await sql.query<BenchmarkDefinitionRow>`
      SELECT benchmarks.id, benchmarks.name, benchmarks.description, benchmarks.contents, benchmarks.field_ids, benchmarks.campaign_field_ids, benchmarks.test_ids, suites.id as suite_id FROM benchmarks
      LEFT JOIN suites ON benchmarks.id=ANY(suites.benchmark_ids)
      WHERE benchmarks.id=ANY(${ids})
      LIMIT ${ids.length}
    `
    this.respondAfterPresenceCheck(req, res, benchmarks, ids)
  }
}
