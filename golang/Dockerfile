FROM golang:1.10.3-stretch AS build-pt

RUN set -x && \
  go get -d github.com/monochromegane/the_platinum_searcher
WORKDIR /go/src/github.com/monochromegane/the_platinum_searcher
RUN set -x && \
  git checkout refs/tags/v2.1.6 && \
  go build -v -o ./pt ./cmd/pt/main.go && \
  mv ./pt /go/bin/

FROM golang:1.10.3-stretch AS build-tools

RUN set -x && \
  go get github.com/golang/lint/golint && \
  go get github.com/jstemmer/gotags && \
  go get github.com/nsf/gocode && \
  go get github.com/rogpeppe/godef && \
  go get golang.org/x/tools/cmd/godoc && \
  go get golang.org/x/tools/cmd/goimports && \
  go get golang.org/x/tools/cmd/gorename

FROM iimuz/neovim:v0.3.0-5
LABEL maintainer iimuz

# go
RUN set -x && \
  apk update && \
  apk add --no-cache go && \
  rm -rf /var/cache/apk/*

# tools
COPY --from=build-pt /go/bin/pt /usr/bin/
COPY --from=build-tools /go/bin/* /usr/bin/
RUN set -x && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  mkdir -p /src/_posts && \
  rm -rf /var/cache/apk/*

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall
