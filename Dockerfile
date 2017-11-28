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
    ctags \
    gcc \
    global \
    libc-dev \
    make \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# add dev user
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev /home/dev
USER dev
ENV HOME /home/dev
ENV LANG en_US.UTF-8

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh \
  && sh $HOME/installer.sh $HOME/.cache/dein \
  && rm $HOME/installer.sh

# install plugins
RUN mkdir -p $HOME/.vim/rc
COPY .vimrc $HOME/.vimrc
COPY dein.toml $HOME/.vim/rc/dein.toml
COPY dein_lazy.toml $HOME/.vim/rc/dein_lazy.toml
RUN vim +":silent! call dein#install()" +qall

WORKDIR ${HOME}

