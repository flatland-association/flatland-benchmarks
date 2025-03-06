import * as esbuild from 'esbuild'

await esbuild.build({
  bundle: true,
  platform: 'node',
  format: 'esm',
  packages: 'external',
  // esbuild does not inspect tsconfig.json "files" to determine entryPoints
  // nor "outDir" to determine outfile, hence, define them here
  // https://esbuild.github.io/content-types/#tsconfig-json
  entryPoints: ['src/app/main.mts'],
  outfile: '../../out-tsc/backend/main.min.mjs',
})