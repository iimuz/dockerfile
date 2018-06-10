FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build
LABEL maintainer iimuz

RUN go get github.com/mattn/memo

FROM iimuz/neovim:v0.2.2-md1
LABEL maintainer iimuz

# memo
COPY --from=build /go/bin/memo /usr/bin/
COPY config.toml /home/dev/.config/memo/config.toml
RUN set -x && \
  mkdir -p /src/_posts

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["memo"]
