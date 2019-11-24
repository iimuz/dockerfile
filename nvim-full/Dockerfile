FROM golang:1.13.0-stretch AS build-go-tools

RUN set -x \
  && go get github.com/jstemmer/gotags \
  && go get github.com/nsf/gocode \
  && go get github.com/rogpeppe/godef \
  && go get golang.org/x/lint/golint \
  && go get golang.org/x/tools/cmd/godoc \
  && go get golang.org/x/tools/cmd/goimports \
  && go get golang.org/x/tools/cmd/gorename

FROM iimuz/neovim:v0.4.2-1
LABEL maintainer iimuz

RUN set -x \
  && : "setting c++ environment" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ctags \
    git \
    global \
    vim-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY .globalrc /.globalrc

# tools
RUN set -x \
  && : "setting golng environment" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ctags \
    git \
    golang \
    vim-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY --from=build-go-tools /go/bin/* /usr/bin/

RUN set -x \
  && : "set node.js environment" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ctags \
    git \
    nodejs \
    npm \
    vim-common \
  && : "install eslint" \
  && npm install -g \
    babel-eslint \
    eslint \
    eslint-plugin-import \
    eslint-plugin-jsx-a11y \
    eslint-plugin-vue \
    eslint-plugin-react \
    eslint-config-airbnb \
    @typescript-eslint/parser \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY .eslintrc /.eslintrc

RUN set -x \
  && : "setting python environment" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ctags \
    git \
    vim-common \
  && pip3 install --no-cache \
    autopep8 \
    black \
    flake8 \
    flake8-import-order \
    isort \
    python-language-server \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "add packages for build" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    make \
  && : "install plugins" \
  && nvim +"silent! call dein#install()" +qall \
  && nvim +"UpdateRemotePlugin" +qall \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME \
  && : "clean" \
  && apt-get remove -y make \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
