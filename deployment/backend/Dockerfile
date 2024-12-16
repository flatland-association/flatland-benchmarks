FROM node:alpine

RUN npm install -g @angular/cli

WORKDIR /usr/src/app

# TODO extract to builder container?
COPY ./*.json /usr/src/app
COPY ts /usr/src/app/ts

RUN npm install

WORKDIR /usr/src/app/ts/backend

# TODO production mode?

CMD ["npm", "run", "serve"]
