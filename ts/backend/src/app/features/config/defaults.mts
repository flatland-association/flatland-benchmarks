export const defaults = {
  /* Public API */
  api: {
    host: 'localhost',
    port: 8000,
  },
  /* AMQP endpoint */
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
  /* Redis endpoint */
  redis: {
    url: 'redis://localhost:6379',
  },
  /* Keycloak endpoint */
  keycloak: {
    url: 'http://localhost:8081',
    realm: 'netzgrafikeditor',
  },
}
