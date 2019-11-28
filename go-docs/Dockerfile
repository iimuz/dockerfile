FROM iimuz/golang-dev:v1.10.3-2 AS build-tools

# tools for go lang
RUN set -x && \
  go get golang.org/x/tools/cmd/godoc

FROM iimuz/golang-dev:v1.10.3-2
LABEL maintainer iimuz

# tools
COPY --from=build-tools /go/bin/* /usr/bin/
RUN set -x && \
  apk update && \
  apk add --no-cache ca-certificates && \
  mkdir /lib64 && \
  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  rm -rf /var/cache/apk/*

CMD ["godoc"]
