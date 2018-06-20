FROM ubuntu:bionic

MAINTAINER sue445 <sue445@sue445.net>

RUN apt-get update && \
    apt-get install -y curl xz-utils git && \
    apt-get clean

RUN curl https://cli-assets.heroku.com/install.sh | sh
