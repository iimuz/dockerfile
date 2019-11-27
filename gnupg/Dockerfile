FROM alpine:3.9
LABEL maintainer iimuz

RUN set -x && \
  : "install packages" && \
  apk update && \
  apk add --no-cache gnupg && \
  : "clean and settings" && \
  rm -rf /var/cache/apk/*

CMD ["git"]

