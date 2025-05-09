export const defaults = {
  /* Public API */
  api: {
    host: '0.0.0.0',
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
    url: 'redis://localhost:6379', // redis[s]://[[username][:password]@][host][:port][/db-number]
  },
  /* S3 */
  s3: {
    protocol: 'http://',
    host: 'localhost',
    port: 9000,
    user: 'minioadmin',
    password: 'minioadmin',
    region: 'eu-central-2', // https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html
    bucket: 'fab-demo-results',
    path: 'results',
  },
  /* Keycloak endpoint */
  keycloak: {
    url: 'http://localhost:8081', // http[s]://[host][:port]
    realm: 'netzgrafikeditor',
    audience: 'fab', // must be present in JWT's aud
    timeout: 30000, // ms
  },
}
