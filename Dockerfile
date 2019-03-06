FROM golang:1.12.0-stretch AS build

WORKDIR /src
ENV HUGO_VERSION=0.54.0
RUN set -x && \
  : "build hugo" && \
  git clone https://github.com/gohugoio/hugo.git && \
  cd hugo && \
  go install

FROM alpine:3.9
LABEL maintainer iimuz

COPY --from=build /go/bin/hugo /usr/bin/
RUN set -x && \
  : "install packages for hugo" && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  rm -rf /var/cache/apk/*

CMD ["hugo"]

