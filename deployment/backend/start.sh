#! /bin/bash
set -euxo pipefail

flyway -url=jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} -schemas=public -user=${POSTGRES_USER} -password=${POSTGRES_PASSWORD} migrate -connectRetries=60 -baselineOnMigrate=true
cd /usr/src/app/dist/backend/app
node main.min.mjs
