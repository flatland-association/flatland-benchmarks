import { appendDir } from '@common/endpoint-utils.js'
import { ScenarioDefinitionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class ScenarioController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/scenarios/:scenario_ids', this.getScenarioById)
  }

  /**
   * @swagger
   * /definitions/scenarios/{scenario_ids}:
   *  get:
   *    description: Returns scenarios with ID in `ids`.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: scenario_ids
   *        description: Comma-separated list of IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *    responses:
   *      200:
   *        description: Requested scenarios.
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
   *                            type: string
   *                            format: uuid
   *                          name:
   *                            type: string
   *                          description:
   *                            type: string
   */
  getScenarioById: GetHandler<'/definitions/scenarios/:scenario_ids'> = async (req, res) => {
    const ids = req.params.scenario_ids.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<ScenarioDefinitionRow>>`
        SELECT * FROM scenario_definitions
        WHERE id=ANY(${ids})
        LIMIT ${ids.length}
      `
    const scenarios = appendDir('/definitions/scenarios/', rows)
    // return array - dev.002
    this.respond(req, res, scenarios)
  }
}
