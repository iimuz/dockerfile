FROM golang:1.13.0-stretch AS build-pt

RUN set -x \
  && go get -d github.com/monochromegane/the_platinum_searcher
WORKDIR /go/src/github.com/monochromegane/the_platinum_searcher
RUN set -x \
  && git checkout refs/tags/v2.2.0 \
  && go build -v -o ./pt ./cmd/pt/main.go \
  && mv ./pt /go/bin/

FROM alpine:3.10
LABEL maintainer iimuz

# xdg base directory
ENV XDG_CACHE_HOME=/.cache \
  XDG_CONFIG_DIRS=/etc/xdg \
  XDG_CONFIG_HOME=/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  XDG_DATA_HOME=/.local/share

COPY --from=build-pt /go/bin/pt /usr/bin/
RUN set -x \
  && : "install for pt" \
  && apk add --no-cache ca-certificates \
  && mkdir /lib64 \
  && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && : "install neovim" \
  && apk update \
  && apk add --no-cache --virtual .build-deps \
    gcc \
    linux-headers \
    musl-dev \
  && apk add --no-cache \
    neovim \
    python2-dev \
    py-pip \
    python3-dev \
  && pip install --upgrade pip \
  && pip install --no-cache setuptools \
  && pip install --no-cache neovim \
  && pip3 install --upgrade pip \
  && pip3 install --no-cache setuptools \
  && pip3 install --no-cache neovim \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/* \
  && nvim --version

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "create xdg base direcotry" \
  && mkdir -p $XDG_CACHE_HOME \
  && mkdir -p $XDG_DATA_HOME \
  && mkdir -p $XDG_CONFIG_HOME/nvim \
  && : "install packages" \
  && apk update \
  && apk add --no-cache git \
  && apk add --no-cache --virtual .fetch-deps curl \
  && : "install dein" \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /opt/installer.sh \
  && sh /opt/installer.sh $XDG_CACHE_HOME/dein \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME \
  && : "cleanup" \
  && rm /opt/installer.sh \
  && rm -rf /opt/dotfiles \
  && apk del .fetch-deps \
  && rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir -p ${SOURCE_DIR}

WORKDIR ${SOURCE_DIR}
CMD ["nvim"]
