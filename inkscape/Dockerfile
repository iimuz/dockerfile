FROM debian:9.4
LABEL maintainer iimuz

# set locale and fonts
RUN set -x && \
  apt update && apt-get install -y --no-install-recommends \
    apt-utils \
    fonts-takao \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# gosu
ENV GOSU_VERSION=1.10
RUN set -x && \
  fetchDeps=' \
    ca-certificates \
    wget \
  ' && \
  apt update && \
  apt install -y --no-install-recommends $fetchDeps && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y

# add user
ENV USER_NAME=inkscape \
  HOME=/home/inkscape \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# inkscape
RUN set -x && \
  apt update && \
  apt install -y --no-install-recommends inkscape && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y && \
  : "for warning" && \
  mkdir -p ${HOME}/.local/share

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["inkscape"]

