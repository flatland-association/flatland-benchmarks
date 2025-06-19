export const defaults = {
  /* Public API */
  api: {
    host: '0.0.0.0',
    port: 8000,
  },
  /* Celery broker endpoint */
  amqp: {
    host: 'localhost',
    port: 5672,
  },
  /* Postgres database server */
  postgres: {
    host: 'localhost',
    port: 5432,
    user: 'benchmarks',
    password: 'benchmarks',
    database: 'benchmarks',
  },
  /* Keycloak endpoint */
  keycloak: {
    url: 'http://localhost:8081', // http[s]://[host][:port]
    realm: 'netzgrafikeditor',
    audience: 'fab', // must be present in JWT's aud
    timeout: 30000, // ms
  },
}
