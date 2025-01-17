/**
 * Utility type for the empty object `{}`.
 */
export type Empty = Record<string, never>

/**
 * Utility type making all `Empty` typed fields in T optional and re-type them
 * as `undefined`, effectively banning them from T.
 */
export type BanEmpty<T> =
  // prettier-ignore
  {
    // build a type that is the intersection of all "Empty" fields made optional
    [K in keyof T as Empty extends T[K] ? K : never]?: undefined
  } & {
    //... and all others as-is
    [K in keyof T as Empty extends T[K] ? never : K]: T[K]
  }

/**
 * Guard type for checking if `T` is not a key of `R`.
 */
export type NotKeyOf<T, R> = T extends keyof R ? never : T
