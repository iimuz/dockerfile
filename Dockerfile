FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build
LABEL maintainer "iimuz"

ENV HUGO_VERSION=0.41
RUN set -x && \
  go get github.com/magefile/mage && \
  go get -d github.com/gohugoio/hugo && \
  cd ${GOPATH:-$HOME/go}/src/github.com/gohugoio/hugo && \
  git checkout refs/tags/v${HUGO_VERSION} && \
  git clean -xdf && \
  git reset --hard && \
  mage vendor && \
  mage install

FROM debian:9.4
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
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y

# add user
ENV USER_NAME=hugo \
  HOME=/home/hugo \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# hugo
COPY --from=build /go/bin/hugo /usr/bin/
ENV SOURCE_DIR=/src
RUN set -x && mkdir -p ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["hugo", "server", "-b", "http://localhost/", "-p", "1313", "--bind", "0.0.0.0"]
