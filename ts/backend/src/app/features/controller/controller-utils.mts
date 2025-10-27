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
