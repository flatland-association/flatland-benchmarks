import { StatusCodes } from 'http-status-codes'

/**
 * Returns `true` if `ids` and `resources` match in length. If not, performs a
 * `presenceCheckFull`.
 * @param resources Resources.
 * @param ids Ids to look for.
 * @param idProperty Property name in `resources` items to compare with id.
 */
export function presenceCheckTrusted<R extends unknown[], K extends keyof R[number]>(
  resources: R,
  ids: R[number][K][],
  idProperty: K = 'id' as K,
) {
  if (resources.length === ids.length) return true
  return presenceCheckFull(resources, ids, idProperty)
}

/**
 * Checks if for every id in `ids` a resource exists in `resources`.
 * @param resources Resources.
 * @param ids Ids to look for.
 * @param idProperty Property name in `resources` items to compare with id.
 */
export function presenceCheckFull<R extends unknown[], K extends keyof R[number]>(
  resources: R,
  ids: R[number][K][],
  idProperty: K = 'id' as K,
) {
  //@ts-expect-error unknown
  return ids.every((id) => resources.find((r) => r[idProperty] === id))
}

/**
 * Returns every id in `ids` for which no resource exists in `resources`.
 * @param resources Resources.
 * @param ids Ids to look for.
 * @param idProperty Property name in `resources` items to compare with id.
 */
export function failedPresenceCheck<R extends unknown[], K extends keyof R[number]>(
  resources: R,
  ids: R[number][K][],
  idProperty: K = 'id' as K,
) {
  //@ts-expect-error unknown
  return ids.filter((id) => !resources.find((r) => r[idProperty] === id))
}

/**
 * Wraps error objects meant to be thrown by controllers. Caught and reported in
 * a well-formed manner by the controller's base class error handler.
 */
export class ControllerError {
  text: string
  dbg: unknown
  status: StatusCodes

  /**
   * Creates a new `ControllerError` object.
   * @param text Text, transmitted in the response's `error` property.
   * @param dbg Optional debug object, transmitted in response's `dbg` property.
   * @param status HTTP Status code, defaults to 500 (Internal Server Error).
   */
  constructor(text: string, dbg: unknown, status = StatusCodes.INTERNAL_SERVER_ERROR) {
    this.text = text
    this.dbg = dbg
    this.status = status
  }
}
