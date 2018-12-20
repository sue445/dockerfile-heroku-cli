FROM node:8-alpine

ENV HEROKU_CLI_VERSION 7.19.4

RUN apk --update --no-cache add bash git openssh-client

RUN npm install -g heroku@${HEROKU_CLI_VERSION} \
 && rm -rf /tmp/* /root/.npm \
 && cd /usr/local/lib/node_modules/npm/ \
 && rm -rf man doc html *.md *.bat *.yml changelogs scripts test AUTHORS LICENSE Makefile \
 && find /usr/local/lib/node_modules/ -name test -o -name tests -o -name .bin -type d | xargs rm -rf
