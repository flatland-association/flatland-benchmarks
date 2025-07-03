import { appendDir } from '@common/endpoint-utils.js'
import { BenchmarkGroupDefinitionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class BenchmarkGroupController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/benchmark-groups', this.getBenchmarkGroups)
    this.attachGet('/definitions/benchmark-groups/:group_ids', this.getBenchmarkGroupById)
  }

  /**
   * @swagger
   * /benchmark-groups:
   *  get:
   *    description: Lists benchmark-groups.
   *    responses:
   *      200:
   *        description: List of benchmark-groups.
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
   *                            description: ID of benchmark-group.
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          setup:
   *                            type: string
   *                          benchmark_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   */
  getBenchmarkGroups: GetHandler<'/definitions/benchmark-groups'> = async (req, res) => {
    const sql = SqlService.getInstance()
    const rows = await sql.query<StripDir<BenchmarkGroupDefinitionRow>>`
      SELECT * FROM benchmark_groups
      ORDER BY name ASC
    `
    const resources = appendDir('/benchmark-groups/', rows)
    this.respond(req, res, resources)
  }

  /**
   * @swagger
   * /benchmark-groups/{group_ids}:
   *  get:
   *    description: Returns benchmark-groups with ID in `group_id`.
   *    parameters:
   *      - in: path
   *        name: group_ids
   *        required: true
   *        schema:
   *          type: string
   *          format: uuid
   *        description: Comma-separated list of IDs.
   *    responses:
   *      200:
   *        description: Requested benchmark-groups.
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
   *                            description: ID of benchmark-group.
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          setup:
   *                            type: string
   *                          benchmark_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   */
  getBenchmarkGroupById: GetHandler<'/definitions/benchmark-groups/:group_ids'> = async (req, res) => {
    const ids = req.params.group_ids.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<BenchmarkGroupDefinitionRow>>`
      SELECT * FROM benchmark_groups
      WHERE id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const benchmarks = appendDir('/benchmark-groups/', rows)
    this.respond(req, res, benchmarks)
  }
}
