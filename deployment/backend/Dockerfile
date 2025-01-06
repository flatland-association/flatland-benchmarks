FROM node:23.5.0-alpine3.20 AS builder
RUN npm install -g @angular/cli

WORKDIR /usr/src/app

COPY ./*.json /usr/src/app
COPY ts /usr/src/app/ts

RUN npm install && cd ts/backend && npm run build



FROM node:23.5.0-alpine3.20

COPY --from=builder /usr/src/app/dist/backend/app /usr/src/app/dist/backend/app
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules

RUN mkdir -p /usr/src/app/dist/backend/config/

WORKDIR /usr/src/app/dist/backend/app

CMD ["node", "main.js"]
