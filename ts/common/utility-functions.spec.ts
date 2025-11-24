import { describe, expect, test } from 'vitest'
import { splitArrayIntoChunks } from './utility-functions'

describe('Utility Functions', () => {
  describe('splitArrayIntoChunks', () => {
    const source = [1, 2, 3, 4, 5]

    test('should split array into fixed sized chunks', () => {
      const chunks = splitArrayIntoChunks(source, 2)
      expect(chunks.length).toBe(3)
      expect(chunks[0].length).toBe(2)
      expect(chunks[1].length).toBe(2)
      expect(chunks[2].length).toBe(1)
    })

    test('should preserve original array', () => {
      splitArrayIntoChunks(source, 2)
      expect(source.length).toBe(5)
    })

    test('should return copy of source as one chunk if chunk size is absurd', () => {
      const chunks = splitArrayIntoChunks(source, 0)
      expect(chunks[0]).toEqual(source)
      expect(chunks.length).toBe(1)
      chunks[0][0] = 1337
      expect(source[0]).toBe(1)
    })
  })
})
