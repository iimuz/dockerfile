FROM buildpack-deps:stretch-scm
LABEL maintainer "iimuz"

# set locale
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# cpp dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    clang-format-3.8 \
    make \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# vim
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libc-dev \
    lua5.2 \
    lua5.2-dev \
    luajit \
    ctags \
    gcc \
    global \
    ncurses-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /opt/ \
  && git clone --depth=1 -b v8.0.1365 https://github.com/vim/vim vim \
  && cd ./vim \
  && ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp=dynamic \
    --enable-gpm \
    --enable-cscope \
    --enable-fontset \
    --enable-fail-if-missing \
    --prefix=/usr/local \
  && make && make install \
  && cd .. \
  && rm -rf vim \
  && vim --version

# add dev user
ENV HOME /home/dev
COPY ./home $HOME
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev $HOME
USER dev

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh \
  && sh $HOME/installer.sh $HOME/.cache/dein \
  && rm $HOME/installer.sh \
  && vim +":silent! call dein#install()" +qall

WORKDIR ${HOME}

