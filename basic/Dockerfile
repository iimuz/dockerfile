# FROM golang:1.10.3-stretch AS build-tools
FROM localhost:go-base AS build-tools

# tools for go lang
RUN set -x && \
  go get github.com/golang/dep/cmd/dep && \
  go get github.com/Masterminds/glide && \
  go get github.com/Songmu/make2help/cmd/make2help

FROM localhost:go-base
LABEL maintainer iimuz

# tools
COPY --from=build-tools /go/bin/* /usr/bin/
RUN set -x && \
  apk update && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  rm -rf /var/cache/apk/*
RUN set -x && \
  apk update && \
  apk add --no-cache make && \
  rm -rf /var/cache/apk/*

