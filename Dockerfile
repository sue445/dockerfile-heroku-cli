FROM node:25-alpine

ARG HEROKU_CLI_VERSION=10.15.0
ENV HEROKU_CLI_VERSION=${HEROKU_CLI_VERSION}

LABEL org.opencontainers.image.title="node-heroku-cli" \
      org.opencontainers.image.description="Node.js (Alpine) with pinned Heroku CLI" \
      org.opencontainers.image.version="${HEROKU_CLI_VERSION}" \
      org.opencontainers.image.source="https://github.com/mmz-srf/dockerfile-heroku-cli" \

# npm noise off
ENV NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_UPDATE_NOTIFIER=false

# needed for git-based deploys and SSH remotes
RUN apk add --no-cache git openssh-client

# Heroku CLI (pinned)
RUN npm install -g "heroku@${HEROKU_CLI_VERSION}" --unsafe-perm \
 && npm cache clean --force

# Non-root user with a real home directory
RUN addgroup -g 1001 -S app \
 && adduser -S -D -u 1001 -G app -h /home/app app \
 && mkdir -p /home/app \
 && chown -R app:app /home/app

RUN test "$(heroku --version | sed -n 's/^heroku\/\([0-9.]*\).*/\1/p')" = "${HEROKU_CLI_VERSION}"


USER 1001:1001
WORKDIR /home/app

ENTRYPOINT ["/bin/sh"]
