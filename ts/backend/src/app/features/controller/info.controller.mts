import { configuration } from '../config/config.mjs'
import { Controller, GetHandler } from './controller.mjs'

export class InfoController extends Controller {
  constructor(config: configuration) {
    super(config)
    this.attachGet('/info', this.getInfo)
  }

  /**
   * @swagger
   * /info:
   *  get:
   *    description: Returns info.
   *    responses:
   *      200:
   *        description: Info
   *        content:
   *          application/json:
   *            schema:
   *              allOf:
   *                - $ref: "#/components/schemas/ApiResponse"
   *                - type: object
   *                  properties:
   *                    body:
   *                      type: object
   *                      properties:
   *                        version:
   *                          type: string
   */
  getInfo: GetHandler<'/info'> = async (req, res) => {
    const version: string = process.env['FAB_VERSION'] || 'UNDEFINED'
    const payload = {
      version: version,
    }
    this.respond(req, res, payload)
  }
}
