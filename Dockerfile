FROM ubuntu:16.04
MAINTAINER iimuz

# set locale
RUN sed -i.bak -e "s%http://us.archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list && \
  apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    language-pack-ja-base \
    language-pack-ja \
    locales && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# install texlive
RUN apt-get update && apt-get install -y --no-install-recommends \
    dvipsk-ja \
    gv \
    texlive \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-lang-cjk \
    xdvik-ja && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# install sphinx
RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    python-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  pip install Sphinx==1.5.6

# add dev user
ENV HOME /home/dev
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev $HOME
USER dev

WORKDIR $HOME

