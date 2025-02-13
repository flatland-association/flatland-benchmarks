/**
 * Splits a string at given position and returns the slices as tuple.
 */
export function splitStringAt(string: string, position: number) {
  return [string.slice(0, position), string.slice(position)]
}
