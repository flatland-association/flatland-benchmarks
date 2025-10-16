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
    const rows = await sql.query<StripDir<BenchmarkDefinitionRow>>`
      SELECT benchmark_definitions.id, benchmark_definitions.name, benchmark_definitions.description, benchmark_definitions.contents, benchmark_definitions.field_ids, benchmark_definitions.campaign_field_ids, benchmark_definitions.test_ids, suites.id as suite_id FROM benchmark_definitions
      LEFT JOIN suites ON benchmark_definitions.id=ANY(suites.benchmark_ids)
      ORDER BY name ASC
    `
    const resources = appendDir('/definitions/benchmarks/', rows)
    this.respond(req, res, resources)
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
    const rows = await sql.query<StripDir<BenchmarkDefinitionRow>>`
      SELECT benchmark_definitions.id, benchmark_definitions.name, benchmark_definitions.description, benchmark_definitions.contents, benchmark_definitions.field_ids, benchmark_definitions.campaign_field_ids, benchmark_definitions.test_ids, suites.id as suite_id FROM benchmark_definitions
      LEFT JOIN suites ON benchmark_definitions.id=ANY(suites.benchmark_ids)
      WHERE benchmark_definitions.id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const benchmarks = appendDir('/definitions/benchmarks/', rows)
    this.respond(req, res, benchmarks)
  }
}
