FROM iimuz/neovim:v0.3.1-1
LABEL maintainer iimuz

COPY .globalrc /.globalrc
RUN set -x && \
  : "install packages" && \
  apk update && \
  apk add --no-cache \
    ctags=5.8-r5 \
    git=2.20.1-r0 \
    vimdiff=8.1.0630-r0 && \
  apk add --no-cache global=6.6.2-r1 \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
  rm -rf /var/cache/apk/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "install plugins" && \
  nvim +"call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

