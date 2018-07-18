FROM iimuz/neovim:v0.3.0-4
LABEL maintainer iimuz

RUN set -x && \
  apk update && \
  apk add --no-cache ctags && \
  pip3 install --no-cache \
    flake8==3.5.0 && \
  rm -rf /var/cache/apk/*

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall
