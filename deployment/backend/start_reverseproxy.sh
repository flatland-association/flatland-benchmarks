#! /bin/bash
set -euxo pipefail

apk add nginx
nginx
#flyway -url=jdbc:postgresql://postgres:5432/${POSTGRES_DB} -schemas=public -user=${POSTGRES_USER} -password=${POSTGRES_PASSWORD} migrate -connectRetries=60 -baselineOnMigrate=true
cd /usr/src/app/dist/backend/app
echo $PWD
ls -al
node main.min.mjs --log-level=ALL --log-stringify
