FROM debian:buster
LABEL maintainer "iimuz"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && : "Install hugo" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    tar \
    wget \
  && export HUGO_VERSION=0.60.1 \
  && export HUGO_ARCHIVE=hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && export HUGO_URL=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/$HUGO_ARCHIVE \
  && export HUGO_TEMP=hugo_expand \
  && wget --quiet $HUGO_URL \
  && mkdir -p $HUGO_TEMP \
  && tar xvzf $HUGO_ARCHIVE -C $HUGO_TEMP \
  && mv $HUGO_TEMP/hugo /usr/bin/ \
  && : "Clean" \
  && rm -r $HUGO_TEMP $HUGO_ARCHIVE \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Install git for .GitInfo" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "create home directory for all user" \
  && mkdir -p /home/dev \
  && chmod 777 /home/dev

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash \
  HOME=/home/dev
CMD ["hugo"]

