FROM golang:1.13.4-buster AS build-tools

RUN set -x \
  && go get github.com/jstemmer/gotags \
  && go get github.com/nsf/gocode \
  && go get github.com/rogpeppe/godef \
  && go get golang.org/x/lint/golint \
  && go get golang.org/x/tools/cmd/godoc \
  && go get golang.org/x/tools/cmd/goimports \
  && go get golang.org/x/tools/cmd/gorename

FROM iimuz/neovim:v0.4.3-2
LABEL maintainer iimuz

# tools
COPY --from=build-tools /go/bin/* /usr/bin/

RUN set -x \
  && : "install golng" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ctags \
    git \
    golang \
    vim-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "install plugins" \
  && nvim +"call dein#install()" +qall \
  && nvim +"UpdateRemotePlugins" +qall \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

