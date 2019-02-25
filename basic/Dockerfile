FROM golang:1.11.5-stretch AS build-pt

RUN set -x && \
  go get -d github.com/monochromegane/the_platinum_searcher
WORKDIR /go/src/github.com/monochromegane/the_platinum_searcher
RUN set -x && \
  git checkout refs/tags/v2.2.0 && \
  go build -v -o ./pt ./cmd/pt/main.go && \
  mv ./pt /go/bin/

FROM alpine:3.9
LABEL maintainer iimuz

# xdg base directory
ENV XDG_CACHE_HOME=/.cache \
  XDG_CONFIG_DIRS=/etc/xdg \
  XDG_CONFIG_HOME=/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  XDG_DATA_HOME=/.local/share

COPY --from=build-pt /go/bin/pt /usr/bin/
RUN set -x && \
  : "install for pt" && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  rm -rf /var/cache/apk/*

RUN set -x && \
  : "install neovim" && \
  apk update && \
  apk add --no-cache --virtual .build-deps \
    gcc=8.2.0-r2 \
    linux-headers=4.18.13-r1 \
    musl-dev=1.1.20-r3 && \
  apk add --no-cache \
    neovim=0.3.1-r1 \
    python-dev=2.7.15-r3 \
    py-pip=18.1-r0 \
    python3-dev=3.6.8-r1 && \
  pip install --upgrade pip && \
  pip install --no-cache setuptools==40.8.0 && \
  pip install --no-cache neovim==0.3.1 && \
  pip3 install --upgrade pip && \
  pip3 install --no-cache setuptools==40.8.0 && \
  pip3 install --no-cache neovim==0.3.1 && \
  apk del .build-deps && \
  rm -rf /var/cache/apk/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "create xdg base direcotry" && \
  mkdir -p $XDG_CACHE_HOME && \
  mkdir -p $XDG_DATA_HOME && \
  mkdir -p $XDG_CONFIG_HOME/nvim && \
  : "install packages" && \
  apk update && \
  apk add --no-cache git && \
  apk add --no-cache --virtual .fetch-deps curl && \
  : "install dein" && \
  curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /opt/installer.sh && \
  sh /opt/installer.sh $XDG_CACHE_HOME/dein && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME && \
  : "cleanup" && \
  rm /opt/installer.sh && \
  rm -rf /opt/dotfiles && \
  apk del .fetch-deps && \
  rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir -p ${SOURCE_DIR}

WORKDIR ${SOURCE_DIR}
CMD ["nvim"]
