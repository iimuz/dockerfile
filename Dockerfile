FROM debian:stretch
LABEL maintainer iimuz

# set locale
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    apt-utils \
    fonts-arphic-uming \
    locales && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    bzip2 \
    gcc \
    git \
    python-gtk2 \
    python2.7 \
    python2.7-dev \
    python-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  python2.7 -m pip install setuptools && \
  python2.7 -m pip install \
    czipfile \
    subprocess32 \
    pillow && \
  cd /opt && \
  git clone -b 1.2.1 --depth 1 https://git.code.sf.net/p/mcomix/git mcomix && \
  cd mcomix && \
  python2.7 -m setup install && \
  cd .. && \
  rm -rf mcomix

# add dev user
ENV HOME /home/dev
COPY ./home $HOME
RUN adduser dev --disabled-password --gecos "" && \
  echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  chown -R dev:dev $HOME
USER dev

WORKDIR ${HOME}
ENTRYPOINT mcomix

