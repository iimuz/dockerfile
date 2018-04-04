FROM python:3.6.3-stretch
LABEL maintainer "iimuz"

# set locale
RUN apt update && apt install -y --no-install-recommends \
    apt-utils \
    task-japanese \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# install texlive
RUN apt update && apt install -y --no-install-recommends \
    texlive \
    texlive-formats-extra \
    texlive-lang-japanese && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

# install sphinx
RUN pip3 install Sphinx==1.5.6

# add dev user
ENV HOME /home/dev
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev $HOME
USER dev

WORKDIR $HOME

