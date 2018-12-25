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
ENV USER_NAME=rsync \
  HOME=/home/rsync \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  apk update && \
  apk add --no-cache su-exec shadow && \
  rm -rf /var/cache/apk/* && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# rsync
RUN set -x && \
  apk update && \
  apk add --no-cache \
    openssh \
    rsync && \
  rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR $SOURCE_DIR
ENTRYPOINT ["/entrypoint.sh"]
CMD ["rsync"]
