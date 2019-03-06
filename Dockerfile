FROM python:3.7.2-alpine
LABEL maintainer "iimuz"

RUN set -x && \
  apk update && \
  apk add --no-cache \
    musl \
    linux-headers \
    gcc \
    g++ \
    make \
    gfortran \
    openblas-dev && \
  rm -rf /var/cache/apk/*

# install pipenv
RUN set -x && \
  : "install pipenv" && \
  pip --no-cache-dir install pipenv && \
  : "set cache dir for pipenv" && \
  mkdir -p /.cache && \
  chmod 777 /.cache
ENV PIPENV_VENV_IN_PROJECT=1

CMD ["python"]

