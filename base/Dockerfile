FROM alpine:3.8

RUN set -x && \
  apk update && \
  apk add --no-cache \
    ca-certificates \
    git && \
  rm -rf /var/apk/cache/*
