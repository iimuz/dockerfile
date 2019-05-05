FROM alpine:3.8
LABEL maintainer iimuz

# clang
RUN set -x && \
  export CLANG_VERSION=3.8.0-r0 && \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache \
    alpine-sdk \
    clang=${CLANG_VERSION} && \
  rm -rf /var/cache/apk/*
ENV CC=clang \
  CXX=clang++

# tools
RUN set -x && \
  apk update && \
  apk add --no-cache \
    cmake \
    make && \
  rm -rf /var/cache/apk/*

CMD ["clang++"]
