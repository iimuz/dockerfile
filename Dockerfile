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

FROM iimuz/neovim:v0.2.2-md1
LABEL maintainer iimuz

# memo
COPY --from=build-memo /go/bin/memo /usr/bin/
COPY config.toml /home/dev/.config/memo/config.toml
RUN set -x && \
  mkdir -p /src/_posts

# peco
COPY --from=build-peco /go/bin/peco /usr/bin/

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["memo"]
