FROM golang:1.10.3-stretch AS build-pt

RUN set -x && \
  go get -d github.com/monochromegane/the_platinum_searcher
WORKDIR /go/src/github.com/monochromegane/the_platinum_searcher
RUN set -x && \
  git checkout refs/tags/v2.1.6 && \
  go build -v -o ./pt ./cmd/pt/main.go && \
  mv ./pt /go/bin/

FROM iimuz/neovim:v0.3.0-5
LABEL maintainer iimuz

# tools
COPY --from=build-pt /go/bin/pt /usr/bin/
RUN set -x && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  mkdir -p /src/_posts && \
  rm -rf /var/cache/apk/*

# packages
COPY .globalrc ${HOME}/.globalrc
RUN set -x && \
  apk update && \
  apk add --no-cache ctags && \
  apk add --no-cache global --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
  rm -rf /var/cache/apk/*

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  apk update && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall && \
  rm -rf /var/cache/apk/*
