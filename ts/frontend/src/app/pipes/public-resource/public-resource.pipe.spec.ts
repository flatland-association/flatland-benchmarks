import { PublicResourcePipe } from './public-resource.pipe'

describe('PublicResourcePipe', () => {
  // Pipe is pure, stateless - no need for BeforeEach
  const pipe = new PublicResourcePipe()

  it('prepends basePath/public/ to file name', () => {
    expect(pipe.transform('test.json')).toMatch(/\/public\/test.json$/)
  })

  it('returns nullish values unchanged', () => {
    expect(pipe.transform('')).toBe('')
    expect(pipe.transform(null)).toBe(null)
    expect(pipe.transform(undefined)).toBe(undefined)
  })
})
