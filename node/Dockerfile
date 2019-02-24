FROM golang:1.10.3-stretch AS build-pt

RUN set -x && \
  go get -d github.com/monochromegane/the_platinum_searcher
WORKDIR /go/src/github.com/monochromegane/the_platinum_searcher
RUN set -x && \
  git checkout refs/tags/v2.1.6 && \
  go build -v -o ./pt ./cmd/pt/main.go && \
  mv ./pt /go/bin/

FROM iimuz/neovim:v0.3.0-5
LABEL maintainer iimuz

# tools
COPY --from=build-pt /go/bin/pt /usr/bin/
RUN set -x && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  mkdir -p /src/_posts && \
  rm -rf /var/cache/apk/*

# add packages
RUN set -x && \
  apk add --no-cache nodejs nodejs-npm && \
  : "install eslint" && \
  npm install -g \
    babel-eslint@10.0.1 \
    eslint@5.14.1 \
    eslint-plugin-import@2.16.0 \
    eslint-plugin-jsx-a11y@6.2.1 \
    eslint-plugin-vue@5.2.2 \
    eslint-plugin-react@7.12.4 \
    eslint-config-airbnb@17.1.0 \
    @typescript-eslint/parser@1.4.1 && \
  rm -rf /var/cache/apk/*
COPY .eslintrc ${HOME}/.eslintrc

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall
