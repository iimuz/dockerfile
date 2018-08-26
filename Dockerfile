# FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build
FROM golang:1.10.3-stretch AS build

ENV HUGO_VERSION=0.47.1
RUN set -x && \
  go get github.com/magefile/mage && \
  go get -d github.com/gohugoio/hugo && \
  cd ${GOPATH:-$HOME/go}/src/github.com/gohugoio/hugo && \
  git checkout refs/tags/v${HUGO_VERSION} && \
  git clean -xdf && \
  git reset --hard && \
  mage vendor && \
  mage install

FROM alpine:3.8
LABEL maintainer iimuz

# locale and timezone
ENV LANG="ja_JP.UTF-8" \
  LANGUAGE="ja_JP:ja" \
  LC_ALL="ja_JP.UTF-8"
RUN set -x && \
  apk update && \
  apk add --no-cache tzdata && \
  rm -rf /var/cache/apk/*

# add user
ENV USER_NAME=hugo \
  HOME=/home/hugo \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  apk update && \
  apk add --no-cache su-exec shadow && \
  rm -rf /var/cache/apk/* && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# hugo
COPY --from=build /go/bin/hugo /usr/bin/
RUN set -x && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  rm -rf /var/cache/apk/*

# tools
RUN set -x && \
  apk add --no-cache make && \
  rm -rf /var/cache/apk/*

# source directory
ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["hugo", "server", "-b", "http://localhost/", "-p", "1313", "--bind", "0.0.0.0"]

