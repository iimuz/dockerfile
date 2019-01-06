FROM python:3.7.0-stretch
LABEL maintainer "iimuz"

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
  apt update && \
  apt install -y --no-install-recommends $fetchDeps && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y

# tools for development
ENV USER_NAME=py \
  HOME=/home/py \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos "" && \
  chown -R ${USER_NAME}:${USER_NAME} ${HOME}

# install pipenv
RUN pip --no-cache-dir install pipenv
ENV PIPENV_VENV_IN_PROJECT=1

# add source directory
ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

# set environments
ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["python"]
