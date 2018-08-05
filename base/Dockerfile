FROM alpine:3.8

RUN set -x && \
  apk update && \
  apk add --no-cache \
    ca-certificates && \
  rm -rf /var/apk/cache/*
