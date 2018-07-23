FROM iimuz/neovim:v0.3.0-5
LABEL maintainer iimuz

# packages
COPY .globalrc ${HOME}/.globalrc
RUN set -x && \
  apk update && \
  apk add --no-cache ctags && \
  apk add --no-cache global --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
  rm -rf /var/cache/apk/*

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  apk update && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall && \
  rm -rf /var/cache/apk/*
