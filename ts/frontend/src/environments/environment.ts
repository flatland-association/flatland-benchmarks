import { envConfig } from './env-config.production'
import { envStatic } from './env-static.fab'

/*
Angular requires one environment to be the default environment and that to be
simply "environment.ts" i.o.t. find the import file path and infer the
`environment` objects type.

This file is synthesized from a config (production/development) and static
content (fab, ai4realnet)

The default synthesizing is "fab.production" - others are achieved by
replacing `env-config` and `env-static` during build. See `/angular.json`.
*/

export const environment = {
  ...envConfig,
  ...envStatic,
}
