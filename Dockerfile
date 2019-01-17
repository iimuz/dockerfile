FROM ruby:2.5.0-stretch
LABEL maintainer iimuz

ENV DEBIAN_FRONTEND noninteractive

# set locale
RUN set -x && \
  apt update && \
  apt install -y --no-install-recommends \
    apt-utils \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# gosu
ENV GOSU_VERSION=1.11
RUN set -x && \
  fetchDeps=' \
    ca-certificates \
    wget \
  ' && \
  apt-get update && \
  apt-get install -y --no-install-recommends $fetchDeps && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get autoremove -y

# add dev user
ENV USER_NAME=dev \
  HOME=/home/dev \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos "" && \
  chown -R ${USER_NAME}:${USER_NAME} ${HOME}

# install travis
RUN set -x && \
  gem install travis -v 1.8.9 --no-rdoc --no-ri

# add source directory
ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR $HOME
ENTRYPOINT ["/entrypoint.sh"]
CMD ["travis"]
