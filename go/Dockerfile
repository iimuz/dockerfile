FROM golang:1.13.5-buster AS build-tools

RUN set -x \
  && : "Build tools for go language." \
  && go get github.com/Songmu/make2help/cmd/make2help \
  && go get golang.org/x/tools/cmd/godoc

FROM golang:1.13.5-buster
LABEL maintainer "iimuz"

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=build-tools /go/bin/* /usr/bin/

RUN set -x \
  && : "Install tools" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    make \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "create home directory for all user" \
  && mkdir -p /home/dev \
  && chmod 777 /home/dev

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash \
  HOME=/home/dev
CMD ["go"]

