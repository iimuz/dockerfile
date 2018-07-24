FROM golang:1.10.3-stretch AS build-tools

# tools for go lang
RUN set -x && \
  go get github.com/golang/dep/cmd/dep && \
  go get github.com/Masterminds/glide

FROM golang:1.10.3-alpine3.8
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
ENV USER_NAME=go \
  HOME=/home/go \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  apk update && \
  apk add --no-cache su-exec shadow && \
  rm -rf /var/cache/apk/* && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# tools
COPY --from=build-tools /go/bin/* /usr/bin/

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR /go
ENTRYPOINT ["/entrypoint.sh"]
CMD ["go"]
