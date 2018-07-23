FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build-memo
LABEL maintainer iimuz

RUN set -x && \
  go get github.com/mattn/memo

FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build-peco
LABEL maintainer iimuz

RUN set -x && \
  go get -d github.com/peco/peco && \
  cd /go/src/github.com/peco/peco && \
  git checkout refs/tags/v0.5.3 && \
  glide install && \
  go build cmd/peco/peco.go && \
  mv ./peco /go/bin/peco

FROM iimuz/neovim:v0.3.0-md5
LABEL maintainer iimuz

# change username
RUN set -x && \
  export NEW_USER_NAME=memo && \
  apk update && \
  apk add --no-cache --virtual .fetch-deps shadow && \
  usermod -l ${NEW_USER_NAME} ${USER_NAME} && \
  usermod -m -d /home/${NEW_USER_NAME} ${NEW_USER_NAME} && \
  groupmod -n ${NEW_USER_NAME} ${USER_NAME} && \
  rm -rf /home/${USER_NAME} && \
  apk del .fetch-deps && \
  rm -rf /var/cache/apk/*
ENV USER_NAME=memo \
  HOME=/home/memo


# memo
COPY --from=build-memo /go/bin/memo /usr/bin/
COPY config.toml /home/dev/.config/memo/config.toml
RUN set -x && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  mkdir -p /src/_posts && \
  rm -rf /var/cache/apk/*

# peco
COPY --from=build-peco /go/bin/peco /usr/bin/

CMD ["memo"]
