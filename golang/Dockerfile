FROM golang:1.10.3-stretch AS build-tools

RUN set -x && \
  go get github.com/golang/lint/golint && \
  go get github.com/jstemmer/gotags && \
  go get github.com/nsf/gocode && \
  go get github.com/rogpeppe/godef && \
  go get golang.org/x/tools/cmd/godoc && \
  go get golang.org/x/tools/cmd/goimports && \
  go get golang.org/x/tools/cmd/gorename

FROM iimuz/neovim:v0.3.1-1
LABEL maintainer iimuz

# tools
COPY --from=build-tools /go/bin/* /usr/bin/

RUN set -x && \
  : "install golng" && \
  apk update && \
  apk add --no-cache \
    ctags=5.8-r5 \
    git=2.20.1-r0 \
    go=1.11.5-r0 \
    vimdiff=8.1.0630-r0 && \
  rm -rf /var/cache/apk/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "install plugins" && \
  nvim +"call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

