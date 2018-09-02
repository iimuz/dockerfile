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
ENV USER_NAME=cpp \
  HOME=/home/cpp \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  apk update && \
  apk add --no-cache su-exec shadow && \
  rm -rf /var/cache/apk/* && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# clang
RUN set -x && \
  export CLANG_VERSION=3.8.0-r0 && \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache \
    alpine-sdk \
    clang=${CLANG_VERSION} && \
  rm -rf /var/cache/apk/*
ENV CC=clang \
  CXX=clang++

# tools
RUN set -x && \
  apk update && \
  apk add --no-cache \
    cmake \
    make && \
  rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && \
  mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["clang++"]
