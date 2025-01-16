/**
 * Utility type turning the empty object `{}` into `null`.
 */
export type EmptyToNull<T> = Record<string, never> extends T ? null : T

/**
 * Utility type making all `null` typed fields in T optional and re-type them
 * as `undefined`, effectively banning them from T.
 */
export type BanNull<T> =
  // prettier-ignore
  {
    // build a type that is the intersection of all "null" fields made optional
    [K in keyof T as null extends T[K] ? K : never]?: undefined
  } & {
    //... and all others as-is
    [K in keyof T as null extends T[K] ? never : K]: T[K]
  }
