import { defineConfig } from 'cypress'

export default defineConfig({
  e2e: {
    baseUrl: 'http://localhost:4200',
  },
  env: {
    auth_base_url: 'http://localhost:8081',
    auth_realm: 'flatland',
    auth_client_id: 'fab',
  },
})
