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

# vim
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc-dev \
    make \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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
  && vim +":silent! call dein#install()" +qall

WORKDIR /src
ENTRYPOINT ["vim"]

