FROM iimuz/neovim:v0.3.7-1
LABEL maintainer iimuz

RUN set -x && \
  : "install packages" && \
  apk update && \
  apk add --no-cache \
    ctags \
    git \
    vimdiff && \
  pip3 install --no-cache \
    autopep8 \
    black \
    flake8 \
    flake8-import-order \
    isort \
    python-language-server && \
  rm -rf /var/cache/apk/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "install plugins" && \
  nvim +"call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

