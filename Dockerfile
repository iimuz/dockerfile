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

# vim
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc-dev \
    make \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# add dev user
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev /home/dev \
  && mkdir /src \
  && chown -R dev:dev /src
USER dev
ENV HOME /home/dev

# install dein.vim
RUN mkdir -p /home/dev/.cache/dein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /home/dev/installer.sh \
  && sh /home/dev/installer.sh /home/dev/.cache/dein \
  && rm /home/dev/installer.sh

# install plugins
RUN mkdir -p /home/dev/.vim/rc
COPY .vimrc /home/dev/.vimrc
COPY dein.toml /home/dev/.vim/rc/dein.toml
COPY dein_lazy.toml /home/dev/.vim/rc/dein_lazy.toml
RUN vim +":silent! call dein#install()" +qall

WORKDIR /src
ENTRYPOINT ["vim"]

