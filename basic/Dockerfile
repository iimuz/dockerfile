FROM alpine:3.8
LABEL maintainer iimuz

# locale and timezone
ENV LANG="ja_JP.UTF-8" \
  LANGUAGE="ja_JP:ja" \
  LC_ALL="ja_JP.UTF-8"
RUN set -x && \
  apk update && \
  apk add --no-cache tzdata && \
  rm -rf /var/cache/apk/*

# neovim
ENV NEOVIM_VERSION=0.3.0-r0
RUN set -x && \
  apk update && \
  apk add --no-cache --virtual .build-deps \
    gcc \
    linux-headers \
    musl-dev && \
  apk add --no-cache \
    neovim=${NEOVIM_VERSION} \
    python-dev \
    py-pip \
    python3-dev \
    py3-pip && \
  pip install --no-cache setuptools && \
  pip install --no-cache neovim==0.2.6 && \
  pip3 install --no-cache setuptools && \
  pip3 install --no-cache neovim==0.2.6 && \
  apk del .build-deps && \
  rm -rf /var/cache/apk/*

ENV XDG_CACHE_HOME=/.cache \
  XDG_CONFIG_DIRS=/etc/xdg \
  XDG_CONFIG_HOME=/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share:$XDG_DATA_DIRS \
  XDG_DATA_HOME=/.local/share
COPY .vim /.vim
RUN set -x && \
  apk update && \
  apk add --no-cache git && \
  apk add --no-cache --virtual .fetch-deps curl && \
  : "get settings" && \
  git clone --depth=1 -b v0.1.0 https://github.com/iimuz/dotfiles.git /opt/dotfiles && \
  : "neovim settings" && \
  mkdir -p $XDG_DATA_HOME && \
  mkdir -p $XDG_CONFIG_HOME/nvim && \
  mv /opt/dotfiles/.config/nvim/init.vim $XDG_CONFIG_HOME/nvim/ && \
  : "dein" && \
  mv /opt/dotfiles/.config/nvim/dein.vim $XDG_CONFIG_HOME/nvim/ && \
  curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /opt/installer.sh && \
  sh /opt/installer.sh $XDG_CACHE_HOME/dein && \
  nvim +":silent! call dein#install()" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME && \
  : "cleanup" && \
  rm /opt/installer.sh && \
  rm -rf /opt/dotfiles && \
  apk del .fetch-deps && \
  rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

WORKDIR ${SOURCE_DIR}
CMD ["nvim"]
