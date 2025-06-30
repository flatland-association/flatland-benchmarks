FROM node:23.5.0-alpine3.20 AS builder
RUN npm install -g @angular/cli

WORKDIR /usr/src/app

COPY ./*.json /usr/src/app
COPY ts /usr/src/app/ts

RUN npm ci && cd ts/backend && npm run build



FROM node:23.5.0-alpine3.20

# bash is required for flyway
RUN apk add wget tar bash

WORKDIR /flyway

ENV FLYWAY_VERSION=11.5.0

# started from: https://documentation.red-gate.com/flyway/reference/usage/command-line
# changed to linux-alpine-x64.tar.gz and added --strip-components for a cleaner structure as inspired by the Dockerfile here: https://github.com/flyway/flyway-docker/blob/main/flyway-docker/dockerfiles/alpine/Dockerfile
RUN wget -qO- https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-alpine-x64.tar.gz | tar -xvz --strip-components=1 \
  && ln -s `pwd`/flyway /usr/local/bin \
  && chmod a+x `pwd`/flyway

COPY --from=builder /usr/src/app/dist/backend/app /usr/src/app/dist/backend/app
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules
# migrations are stored in the flyway directory under sql/
# Include schema at build time. If required, mount demo data at run time to /flyway/sql/data
COPY --from=builder /usr/src/app/ts/backend/src/migration/schema /flyway/sql/schema

RUN mkdir -p /usr/src/app/public
COPY ts/backend/src/public.ai4realnet /usr/src/public.ai4realnet
COPY ts/backend/src/public.fab /usr/src/public.fab
RUN find /usr/src/public.*

RUN mkdir -p /usr/src/app/dist/backend/config/
RUN mkdir -p /usr/src/app/dist/backend/public/


COPY deployment/backend/start.sh .

# make sure the script can be executed
# https://stackoverflow.com/a/38882798/10135201
RUN chmod a+x ./start.sh

ENTRYPOINT ["./start.sh"]
