FROM buildpack-deps:stretch-scm
LABEL maintainer iimuz

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

# neovim
ENV NVIM_VERSION=v0.2.2
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    cmake \
    g++ \
    libtool \
    libtool-bin \
    make \
    pkg-config \
    python3 \
    python3-pip \
    python3-setuptools \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /opt/ \
  && git clone --depth=1 -b ${NVIM_VERSION} https://github.com/neovim/neovim.git neovim \
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
  && mkdir $HOME/src \
  && chown -R dev:dev $HOME
USER dev

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${HOME}/installer.sh \
  && sh ${HOME}/installer.sh ${HOME}/.cache/dein \
  && rm ${HOME}/installer.sh \
  && nvim +":silent! call dein#install()" +qall

WORKDIR ${HOME}/src
ENTRYPOINT ["nvim"]

