FROM localhost:nvim
LABEL maintainer iimuz

RUN set -x && \
  : "install linter packages" && \
  apk update && \
  apk add --no-cache ctags && \
  pip3 install --no-cache \
    flake8==3.7.6 && \
  rm -rf /var/cache/apk/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "install plugins" && \
  nvim +"call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME
