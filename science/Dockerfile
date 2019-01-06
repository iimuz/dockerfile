FROM python:3.6.3-stretch
LABEL maintainer "iimuz"

# set locale
RUN set -x && \
  apt update && apt-get install -y --no-install-recommends \
    apt-utils \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

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
  apt purge -y $fetchDeps && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y

# python packages
RUN pip3 install --no-cache-dir \
  matplotlib==2.1.0 \
  numpy==1.13.3 \
  pandas==0.21.0 \
  scipy==1.0.0 \
  scikit-learn==0.19.1 \
  scikit-image==0.13.1

# add user
ENV USER_NAME=py \
  HOME=/home/py \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["python"]

