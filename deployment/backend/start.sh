#! /bin/bash
set -euxo pipefail

if [[ -n "$CUSTOMIZATION" ]]; then
   RUN cp -R /usr/src/public.${CUSTOMIZATION}/* /usr/src/app/dist/backend/public/
fi


flyway -url=jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} -schemas=public -user=${POSTGRES_USER} -password=${POSTGRES_PASSWORD} migrate -connectRetries=60 -baselineOnMigrate=true
cd /usr/src/app/dist/backend/app
node main.min.mjs
