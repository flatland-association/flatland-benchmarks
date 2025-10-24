import { FieldDefinitionRow } from '@common/interfaces.js'
import { configuration } from '../config/config.mjs'
import { SqlService } from '../services/sql-service.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class FieldController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/definitions/fields/:field_ids', this.getFieldById)
  }

  /**
   * @swagger
   * /definitions/fields/{field_ids}:
   *  get:
   *    description: Returns fields with ID in `ids`.
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
   *                          id:
   *                            type: string
   *                            format: uuid
   *                          key:
   *                            type: string
   *                          description:
   *                            type: string
   */
  getFieldById: GetHandler<'/definitions/fields/:field_ids'> = async (req, res) => {
    const ids = req.params.field_ids.split(',')
    const sql = SqlService.getInstance()
    // id=ANY - dev.003
    const fields = await sql.query<FieldDefinitionRow>`
        SELECT * FROM field_definitions
        WHERE id=ANY(${ids})
        LIMIT ${ids.length}
      `
    // return array - dev.002
    this.respondAfterPresenceCheck(req, res, fields, ids)
  }
}
