import { Resource } from './interfaces'

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
    // Required<T> is required, otherwise objects with nothing but optional
    // fields would be treated as empty.
    [K in keyof T as Empty extends Required<T[K]> ? K : never]?: undefined
  } & {
    //... and all others as-is
    [K in keyof T as Empty extends Required<T[K]> ? never : K]: T[K]
  }

/**
 * Utility type removing all properties with type `never`.
 */
export type NoNever<T> = {
  [K in keyof T as T[K] extends never ? never : K]: T[K]
}

/**
 * Guard type checking that `T` is not a key of `R`.
 */
export type NotKeyOf<T, R> = T extends keyof R ? never : T

// https://stackoverflow.com/a/50644844/10135201
/**
 * Guard type checking that `T` is not a union type.
 */
export type NotUnion<T, U = T> = U extends T ? ([T] extends [U] ? T : never) : never

// `undefined` does not actually occur in JSON, but it's allowed as value in
// `JSON.stringify`.
/**
 * Data type for values that can be serialized and deserialized using
 * `JSON.stringify` and `JSON.parse`.
 */
export type json = boolean | number | string | object | null | undefined

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

/**
 * Strip the `id` field from given type/interface. Used for typed post requests
 * where `id` is never part of the request.
 */
// export type StripId<T> = Omit<T, 'id'>

/**
 * Strip the `dir` field from given type/interface. Used for typed sql queries,
 * where `dir` is never part of the result.
 */
export type StripDir<T> = Omit<T, 'dir'>

/**
 * Strip the `id` and `dir` fields from given type/interface. Used for typed
 * post requests, where they're never part of the request body.
 */
export type StripLocator<T> = Omit<T, 'id' | 'dir'>

/**
 * Directory in which a resource lies.
 * For automatic resource fetching, this must match the static part in the
 * corresponding GET endpoint, i.e:
 * ```
 * endpoint = `${ResourceDir}:id`
 * ```
 */
export type ResourceDir = `/${string}/`

/**
 * How a resource is identified within its directory.
 */
export type ResourceId = number | string

/**
 * Composite resource locator - directory / id tuple. The reason this is a
 * tuple and not simply `Resource` is additional type safety.
 */
export type ResourceLocator<R extends Resource> = [R['dir'], ResourceId]

/**
 * Consolidated composite resource locator - directory / ids tuple.
 * Makes programmatically merging and splitting resources from the same
 * directory easier.
 */
export type ConsolidatedResourceLocator<R extends Resource> = [R['dir'], ResourceId[]]

/**
 * Common type of elements in array.
 * Array has to be defined as literal `as const` for this utility to work.
 */
export type ElementType<T extends readonly unknown[]> = T extends readonly (infer E)[] ? E : never

/**
 * Common property type of elements in array. Array has
 * Array has to be defined as literal `as const` for this utility to work.
 */
export type ElementPropertyType<T extends readonly unknown[], P extends string> = T extends readonly Record<
  P,
  infer E
>[]
  ? E
  : never
