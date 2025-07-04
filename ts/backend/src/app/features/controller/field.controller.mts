import { appendDir } from '@common/endpoint-utils.js'
import { FieldDefinitionRow } from '@common/interfaces.js'
import { StripDir } from '@common/utility-types.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class FieldController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/fields/:field_ids', this.getFielddById)
  }

  /**
   * @swagger
   * /definitions/fields/{field_ids}:
   *  get:
   *    description: Returns fields with ID in `ids`.
   *    security:
   *      - oauth2: [user]
   *    parameters:
   *      - in: path
   *        name: field_ids
   *        description: Comma-separated list of IDs.
   *        required: true
   *        schema:
   *          type: array
   *          items:
   *            type: string
   *            format: uuid
   *    responses:
   *      200:
   *        description: Requested fields.
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
   *                          key:
   *                            type: string
   *                          description:
   *                            type: string
   */
  getFielddById: GetHandler<'/definitions/fields/:field_ids'> = async (req, res) => {
    const ids = req.params.field_ids.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const rows = await sql.query<StripDir<FieldDefinitionRow>>`
        SELECT * FROM field_definitions
        WHERE id=ANY(${ids})
        LIMIT ${ids.length}
      `
    const fields = appendDir('/definitions/fields/', rows)
    // return array - dev.002
    this.respond(req, res, fields)
  }
}
