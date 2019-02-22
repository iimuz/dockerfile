FROM node:8.15.0-alpine
LABEL maintainer iimuz

RUN set -x && \
  : "install vue-cli" && \
  npm install --quiet --global @vue/cli@3.4.1

RUN set -x && \
  : "create source directory" && \
  mkdir /src

WORKDIR /src
ENTRYPOINT ["vue"]
