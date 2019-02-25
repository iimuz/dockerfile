FROM alpine:3.9
LABEL maintainer iimuz

# xdg base directory
ENV XDG_CACHE_HOME=/.cache \
  XDG_CONFIG_DIRS=/etc/xdg \
  XDG_CONFIG_HOME=/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share:$XDG_DATA_DIRS \
  XDG_DATA_HOME=/.local/share

RUN set -x && \
  : "install neovim" && \
  apk update && \
  apk add --no-cache --virtual .build-deps \
    gcc=8.2.0-r2 \
    linux-headers=4.18.13-r1 \
    musl-dev=1.1.20-r3 && \
  apk add --no-cache \
    neovim=0.3.1-r1 \
    python-dev=2.7.15-r3 \
    py-pip=18.1-r0 \
    python3-dev=3.6.8-r1 && \
  pip install --upgrade pip && \
  pip install --no-cache setuptools==40.8.0 && \
  pip install --no-cache neovim==0.3.1 && \
  pip3 install --upgrade pip && \
  pip3 install --no-cache setuptools==40.8.0 && \
  pip3 install --no-cache neovim==0.3.1 && \
  apk del .build-deps && \
  rm -rf /var/cache/apk/*

COPY .vim /.vim
RUN set -x && \
  : "set xdg base direcotry" && \
  mkdir -p $XDG_CACHE_HOME && \
  mkdir -p $XDG_DATA_HOME && \
  mkdir -p $XDG_CONFIG_HOME/nvim && \
  : "install packages" && \
  apk update && \
  apk add --no-cache git && \
  apk add --no-cache --virtual .fetch-deps curl && \
  : "get settings" && \
  git clone --depth=1 -b v0.1.0 https://github.com/iimuz/dotfiles.git /opt/dotfiles && \
  mv /opt/dotfiles/.config/nvim/init.vim $XDG_CONFIG_HOME/nvim/ && \
  : "install dein and plugins" && \
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
RUN set -x && mkdir -p ${SOURCE_DIR}

WORKDIR ${SOURCE_DIR}
CMD ["nvim"]
