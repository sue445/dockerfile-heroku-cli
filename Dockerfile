FROM node:8-alpine

RUN apk --update add bash git \
 && npm install -g heroku-cli
