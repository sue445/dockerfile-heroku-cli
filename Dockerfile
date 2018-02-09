FROM node:8-alpine

RUN apk --update --no-cache add bash git \
 && npm install -g heroku-cli

# Cleanup unused all files!
# c.f. https://github.com/wingrunr21/alpine-heroku-cli/commit/4763ae03f9cf80c9c03fb208866e519733aa3ff3
RUN rm -rf /tmp/* /root/.npm \
 && cd /usr/local/lib/node_modules/npm/ \
 && rm -rf man doc html *.md *.bat *.yml changelogs scripts test AUTHORS LICENSE Makefile \
 && find /usr/local/lib/node_modules/ -name test -o -name tests -o -name .bin -type d | xargs rm -rf
