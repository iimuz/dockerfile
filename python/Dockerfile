FROM iimuz/neovim:v0.3.1-1
LABEL maintainer iimuz

RUN set -x && \
  : "install packages" && \
  apk update && \
  apk add --no-cache \
    ctags=5.8-r5 \
    git=2.20.1-r0 \
    vimdiff=8.1.0630-r0 && \
  pip3 install --no-cache \
    autopep8==1.4.3 \
    black==18.9b0 \
    flake8==3.7.6 \
    flake8-import-order==0.18 \
    isort==4.3.8 \
    python-language-server==0.24.0 && \
  rm -rf /var/cache/apk/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "install plugins" && \
  nvim +"call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME
