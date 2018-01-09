FROM buildpack-deps:stretch-scm
LABEL maintainer iimuz

# set locale
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    locales && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# setup tools
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake \
    make && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# clang
RUN echo deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-5.0 main >> /etc/apt/sources.list && \
  echo deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-5.0 main >> /etc/apt/sources.list.d/deb-src.list  && \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    clang-5.0 \
    libclang-common-5.0-dev \
    libclang-5.0-dev \
    libclang1-5.0 \
    libclang1-5.0-dbg \
    libllvm5.0 \
    libllvm5.0-dbg \
    lldb-5.0 \
    llvm-5.0 \
    llvm-5.0-dev \
    llvm-5.0-runtime \
    clang-format-5.0 \
    liblldb-5.0-dev \
    lld-5.0 \
    libfuzzer-5.0-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ENV CC=clang-5.0 \
  CXX=clang++-5.0

# vim
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    ctags \
    lua5.2 \
    lua5.2-dev \
    global && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  cd /opt/ && \
  git clone --depth=1 -b v8.0.1365 https://github.com/vim/vim vim && \
  cd ./vim && \
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp \
    --enable-fail-if-missing \
    --prefix=/usr/local && \
  make && \
  make install && \
  cd .. && \
  rm -rf vim && \
  vim --version

# add dev user
ENV HOME /home/dev
COPY ./home $HOME
RUN adduser dev --disabled-password --gecos "" && \
  echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  chown -R dev:dev $HOME
USER dev

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein && \
  curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh && \
  sh $HOME/installer.sh $HOME/.cache/dein && \
  rm $HOME/installer.sh && \
  vim +":silent! call dein#install()" +qall

WORKDIR ${HOME}
