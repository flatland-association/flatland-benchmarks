import { defineConfig } from 'vite'
import tsconfigPaths from 'vite-tsconfig-paths'

export default defineConfig({
  // tsconfigPaths is required to resolve path aliases ("paths") from tsconfig
  plugins: [tsconfigPaths()],
  test: {
    projects: [
      {
        extends: true,
        test: {
          name: 'unit',
          include: ['./src/**/*.spec.ts', '../common/**/*.spec.ts'],
        },
      },
      {
        extends: true,
        test: {
          name: 'integration',
          globalSetup: './test/integration/setup.mts',
          include: ['./test/integration/**/*.spec.ts'],
          globals: true,
        },
      },
      {
        extends: true,
        test: {
          name: 'integration-no-setup',
          include: ['./test/integration/**/*.spec.ts'],
          globals: true,
        },
      },
    ],
    coverage: {
      provider: 'v8',
      include: ['src/**/*.mts'],
      reporter: ['text', 'html', 'cobertura'],
      reportsDirectory: './test/coverage',
    },
  },
})
