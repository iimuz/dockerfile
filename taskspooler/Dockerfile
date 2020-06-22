FROM ubuntu:18.04
LABEL maintainer "iimuz"

ENV HOME=/home/dev
ENV XDG_CACHE_HOME=$HOME/.cache \
  XDG_CONFIG_DIRS=$HOME/etc/xdg \
  XDG_CONFIG_HOME=$HOME/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  XDG_DATA_HOME=$HOME/.local/share
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && : "create home directory for all user" \
  && mkdir -p $HOME \
  && chmod 777 $HOME

RUN set -x \
  && : "Install development tools" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Install task spooler" \
  && wget http://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz \
  && tar xvzf ts-1.0.tar.gz \
  && cd ts-1.0 \
  && make \
  && make install \
  && cd .. \
  && : "Clean" \
  && rm -r ts-1.0 \
  && rm -r ts-1.0.tar.gz

RUN set -x \
  && : "Set directory permission" \
  && chmod -R 777 $HOME

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash
CMD ["ts"]
