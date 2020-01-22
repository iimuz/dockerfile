FROM node:13.6.0-buster
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

RUN set -x \
  && : "Set global install directory for users." \
  && npm config set prefix "$XDG_DATA_HOME/npm-global"
ENV PATH=$XDG_DATA_HOME/npm-global/bin:$PATH

RUN set -x \
  && : "Create home directory for all user" \
  && mkdir -p /home/dev \
  && chmod -R 777 /home/dev

ENV SOURCE_DIR=/workspace
RUN set -x \
  && : "Create workspace for all user" \
  && mkdir -p $SOURCE_DIR \
  && chmod 777 $SOURCE_DIR
WORKDIR $SOURCE_DIR

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash
CMD ["node"]

