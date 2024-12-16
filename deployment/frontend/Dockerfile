FROM node:alpine

RUN npm install -g @angular/cli

WORKDIR /usr/src/app

# TODO extract to builder container?
COPY ./*.json /usr/src/app
COPY ts /usr/src/app/ts

RUN cd ts/frontend && npm install && ng build

# TODO make dist and run behind nginx instead?
CMD ["ng", "serve", "--host", "0.0.0.0"]
