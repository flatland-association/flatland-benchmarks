import { defineConfig } from 'vite'
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  // tsconfigPaths is required to resolve path aliases ("paths") from tsconfig
  plugins: [tsconfigPaths()],
})
