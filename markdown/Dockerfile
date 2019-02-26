FROM iimuz/neovim:v0.3.1-1
LABEL maintainer iimuz

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "add packages for build" && \
  apk add --no-cache --virtual .build-deps \
    make && \
  : "install plugins" && \
  nvim +"silent! call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME && \
  : "clean" && \
  # apk del .build-deps && \
  rm -rf /var/cache/apk/*

