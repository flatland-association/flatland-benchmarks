FROM node:23.5.0-alpine3.20 AS builder
RUN npm install -g @angular/cli

WORKDIR /usr/src/app

COPY ./*.json /usr/src/app
COPY ts /usr/src/app/ts

RUN npm ci && cd ts/frontend && npm run build



FROM nginx:latest

COPY ./deployment/frontend/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/app/dist/frontend/browser /usr/share/nginx/html

EXPOSE 80
