FROM python:3.6.3-stretch
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

# python packages
RUN pip3 install --no-cache-dir \
  matplotlib==2.1.0 \
  numpy==1.13.3 \
  pandas==0.21.0 \
  scipy==1.0.0 \
  scikit-learn==0.19.1 \
  scikit-image==0.13.1 \
  flake8==3.5.0

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

# neovim
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    cmake \
    g++ \
    libtool \
    libtool-bin \
    pkg-config \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /opt/ \
  && git clone --depth=1 -b v0.2.2 https://github.com/neovim/neovim.git neovim \
  && cd ./neovim \
  && make && make install \
  && cd .. \
  && rm -rf ./neovim \
  && nvim --version \
  && pip3 install neovim

# add dev user
ENV HOME /home/dev
COPY ./home $HOME
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev /home/dev
USER dev

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh \
  && sh $HOME/installer.sh $HOME/.cache/dein \
  && rm $HOME/installer.sh \
  && vim +":silent! call dein#install()" +qall
# install dein.vim to neodein folder
RUN mkdir -p ${HOME}/.cache/neodein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh \
  && sh $HOME/installer.sh $HOME/.cache/neodein \
  && rm $HOME/installer.sh \
  && nvim +":silent! call dein#install()" +qall

WORKDIR ${HOME}

