FROM golang:1.13.4-buster AS build-pt

RUN set -x \
  && go get -d github.com/monochromegane/the_platinum_searcher
WORKDIR /go/src/github.com/monochromegane/the_platinum_searcher
RUN set -x \
  && git checkout refs/tags/v2.2.0 \
  && go build -v -o ./pt ./cmd/pt/main.go \
  && mv ./pt /go/bin/

FROM ubuntu:18.04
LABEL maintainer iimuz

# xdg base directory
ENV HOME=/home/dev
ENV XDG_CACHE_HOME=$HOME/.cache \
  XDG_CONFIG_DIRS=$HOME/etc/xdg \
  XDG_CONFIG_HOME=$HOME/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  XDG_DATA_HOME=$HOME/.local/share
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && : "Set locale" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    locales \
    locales-all \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
ENV LC_ALL=en_US.UTF-8 \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en

# install pt
COPY --from=build-pt /go/bin/pt /usr/bin/

RUN set -x \
  && : "Install neovim" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
  && wget -q https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage \
  && chmod u+x ./nvim.appimage \
  && ./nvim.appimage --appimage-extract \
  && rm nvim.appimage \
  && mv ./squashfs-root /opt/nvim \
  && chmod -R +rx /opt/nvim \
  && ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim \
  && apt-get install -y --no-install-recommends \
    python \
    python-pip \
    python3-dev \
    python3-pip \
  && : "Ignore pip upgrade warning" \
  && pip install --no-cache setuptools \
  && pip install --no-cache pynvim \
  && pip3 install --no-cache setuptools \
  && pip3 install --no-cache pynvim \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && nvim --version

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "Create xdg base direcotry" \
  && mkdir -p $XDG_CACHE_HOME \
  && mkdir -p $XDG_DATA_HOME \
  && mkdir -p $XDG_CONFIG_HOME/nvim \
  && : "Install packages" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    git \
  && : "Install dein" \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /opt/installer.sh \
  && sh /opt/installer.sh $XDG_CACHE_HOME/dein \
  && : "Setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME \
  && : "Cleanup" \
  && rm /opt/installer.sh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Create home directory for all user" \
  && mkdir -p /home/dev \
  && chmod 777 /home/dev

ENV SOURCE_DIR=/workspace
RUN set -x \
  && : "Create workspace for all user" \
  && mkdir -p $SOURCE_DIR \
  && chmod 777 $SOURCE_DIR
WORKDIR $SOURCE_DIR

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash
CMD ["nvim"]
