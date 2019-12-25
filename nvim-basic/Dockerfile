FROM debian:buster
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
  && : "Install basic tools" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    wget \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Install python" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    python \
    python-pip \
    python3-dev \
    python3-pip \
  && : "Ignore pip upgrade warning" \
  && pip install --no-cache setuptools \
  && pip3 install --no-cache setuptools \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Install node.js" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    npm \
  && npm -g install yarn \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Install ruby" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    gcc \
    make \
    ruby \
    ruby-dev \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Install ripgrep" \
  && RIPGREP_VERSION=11.0.2 \
  && RIPGREP_DEB=ripgrep_${RIPGREP_VERSION}_amd64.deb \
  && RIPGREP_URL=https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${RIPGREP_DEB} \
  && curl -LO $RIPGREP_URL \
  && dpkg -i $RIPGREP_DEB \
  && rm $RIPGREP_DEB

RUN set -x \
  && : "Install neovim" \
  && wget -q https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage \
  && chmod u+x ./nvim.appimage \
  && ./nvim.appimage --appimage-extract \
  && mv ./squashfs-root /opt/nvim \
  && chmod -R +rx /opt/nvim \
  && ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim \
  && : "Install nvim tool" \
  && pip install --no-cache pynvim \
  && pip3 install --no-cache pynvim \
  && npm install -g neovim \
  && gem install neovim \
  && : "Clean" \
  && rm nvim.appimage

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "Create xdg base direcotry" \
  && mkdir -p $XDG_CACHE_HOME \
  && mkdir -p $XDG_DATA_HOME \
  && mkdir -p $XDG_CONFIG_HOME/nvim \
  && : "Install dein" \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /opt/installer.sh \
  && sh /opt/installer.sh $XDG_CACHE_HOME/dein \
  && : "Setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME \
  && : "Cleanup" \
  && rm /opt/installer.sh

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
CMD ["nvim"]

