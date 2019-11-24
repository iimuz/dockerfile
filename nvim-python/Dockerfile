FROM iimuz/neovim:v0.4.2-1
LABEL maintainer iimuz

RUN set -x \
  && : "install packages" \
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
  && : "install plugins" \
  && nvim +"call dein#install()" +qall \
  && nvim +"UpdateRemotePlugin" +qall \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME
