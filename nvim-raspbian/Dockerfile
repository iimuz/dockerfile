FROM balenalib/raspberry-pi-python:3.7.3
LABEL maintainer iimuz

# xdg base directory
ENV XDG_CACHE_HOME=/.cache \
  XDG_CONFIG_DIRS=/etc/xdg \
  XDG_CONFIG_HOME=/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  XDG_DATA_HOME=/.local/share

RUN set -x \
  : "install neovim" \
  && apt-get update \
  && apt-get install -y \
    neovim

RUN set -x \
  && apt-get install -y \
    gcc \
    libc-dev \
    raspberrypi-kernel-headers \
    musl-dev

RUN set -x \
  && python --version \
  && python3 --version \
  && pip --version \
  && pip3 --version \
  && pip3 install --upgrade pip \
  && pip3 install --no-cache setuptools \
  && pip3 install --no-cache neovim \
  && apt-get autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lits/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "create xdg base direcotry" && \
  mkdir -p $XDG_CACHE_HOME && \
  mkdir -p $XDG_DATA_HOME && \
  mkdir -p $XDG_CONFIG_HOME/nvim && \
  : "install packages" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    curl \
    git && \
  : "install dein" && \
  curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /opt/installer.sh && \
  sh /opt/installer.sh $XDG_CACHE_HOME/dein && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME && \
  : "cleanup" && \
  rm /opt/installer.sh && \
  rm -rf /opt/dotfiles && \
  apt-get clean && \
  rm -rf /var/lib/apt/lits/*

WORKDIR /workspace
CMD ["nvim"]

