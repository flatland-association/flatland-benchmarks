import { appendDir } from '@common/endpoint-utils.js'
import { SuiteDefinitionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class SuiteController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/suites', this.getSuites)
    this.attachGet('/definitions/suites/:suite_ids', this.getSuiteById)
  }

  /**
   * @swagger
   * /definitions/suites:
   *  get:
   *    description: Lists suites.
   *    responses:
   *      200:
   *        description: List of suites.
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
   *                            description: ID of suite.
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          contents:
   *                            type: object
   *                            description: Additional textual contents for page.
   *                          setup:
   *                            type: string
   *                          benchmark_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   */
  getSuites: GetHandler<'/definitions/suites'> = async (req, res) => {
    const sql = SqlService.getInstance()
    const rows = await sql.query<StripDir<SuiteDefinitionRow>>`
      SELECT * FROM suites
      ORDER BY name ASC
    `
    const resources = appendDir('/definitions/suites/', rows)
    this.respond(req, res, resources)
  }

  /**
   * @swagger
   * /definitions/suites/{suite_ids}:
   *  get:
   *    description: Returns suites with ID in `suite_ids`.
   *    parameters:
   *      - in: path
   *        name: suite_ids
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *        description: Comma-separated list of IDs.
   *    responses:
   *      200:
   *        description: Requested suites.
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
   *                            description: ID of suite.
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   *                          contents:
   *                            type: object
   *                            description: Additional textual contents for page.
   *                          setup:
   *                            type: string
   *                          benchmark_ids:
   *                            type: array
   *                            items:
   *                              type: string
   *                              format: uuid
   */
  getSuiteById: GetHandler<'/definitions/suites/:suite_ids'> = async (req, res) => {
    const ids = req.params.suite_ids.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<SuiteDefinitionRow>>`
      SELECT * FROM suites
      WHERE id=ANY(${ids})
      LIMIT ${ids.length}
    `
    const suites = appendDir('/definitions/suites/', rows)
    this.respond(req, res, suites)
  }
}
