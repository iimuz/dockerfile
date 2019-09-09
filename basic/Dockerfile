FROM golang:1.13.0-stretch AS build-pt

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
ENV XDG_CACHE_HOME=/.cache \
  XDG_CONFIG_DIRS=/etc/xdg \
  XDG_CONFIG_HOME=/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  XDG_DATA_HOME=/.local/share

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
  && : "install neovim" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
  && wget -q https://github.com/neovim/neovim/releases/download/v0.3.8/nvim.appimage \
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
  && : "ignore pip upgrade warning" \
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
  && : "create xdg base direcotry" \
  && mkdir -p $XDG_CACHE_HOME \
  && mkdir -p $XDG_DATA_HOME \
  && mkdir -p $XDG_CONFIG_HOME/nvim \
  && : "install packages" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    git \
  && : "install dein" \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /opt/installer.sh \
  && sh /opt/installer.sh $XDG_CACHE_HOME/dein \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME \
  && : "cleanup" \
  && rm /opt/installer.sh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir -p ${SOURCE_DIR}

WORKDIR ${SOURCE_DIR}
CMD ["nvim"]
