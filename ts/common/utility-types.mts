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

// `undefined` does not actually occur in JSON, but it's allowed as value in
// `JSON.stringify`.
/**
 * Data type for values that can be serialized and deserialized using
 * `JSON.stringify` and `JSON.parse`.
 */
export type json = boolean | number | string | null | undefined | { [key: string]: json } | json[]

/**
 * Coerces given type to accept `string | number` where it initially only
 * accepted `string`.
 */
export type AcceptNumberAsString<T> =
  // prettier-ignore
  {
    // remap all keys
    [K in keyof T]:
      //... from string
      T[K] extends string ? string | number :
      //... from string | undefined
      T[K] extends string | undefined ? string | number | undefined :
      //... leave the rest as-is
      T[K]
  }
// TODO: decide whether it should coerce deep or top level only
// TODO: decide whether string | null should also be coerced
// TODO: decide whether it should accept all primitives (+ rename)

/**
 * Utility type removing all optional fields.
 */
export type RequiredOnly<T> = {
  [K in keyof T as T[K] extends Required<T>[K] ? K : never]: T[K]
}

/**
 * Utility type removing all required fields.
 */
export type OptionalOnly<T> = {
  [K in keyof T as T[K] extends Required<T>[K] ? never : K]: T[K]
}
