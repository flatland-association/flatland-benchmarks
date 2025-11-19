/**
 * Educated guess about how many UUIDs fit into a request URL.
 */
export const MAX_UUIDS_PER_REQUEST = Math.floor((2000 - 128) / 37)
// 2000 is the advised maximum URL length as per several SO threads
// 128 is an arbitrary safety margin that should hold enough space for the API base
// 37 is the length of a UUID + ,

/**
 * Splits an array into chunks of given size.
 * @param source Source array.
 * @param chunkSize Elements per chunk (last chunk can be smaller).
 * @returns Chunks as array of arrays.
 */
export function splitArrayIntoChunks<T>(source: T[], chunkSize = 10): T[][] {
  // return the whole source array as one big chunk if size is "invalid"
  if (chunkSize <= 0) {
    return [[...source]]
  }
  const chunks: T[][] = []
  for (let i = 0; i < source.length; i += chunkSize) {
    chunks.push(source.slice(i, i + chunkSize))
  }
  return chunks
}
