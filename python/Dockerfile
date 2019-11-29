FROM python:3.7.5-buster
LABEL maintainer "iimuz"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x && \
  : "install pipenv" && \
  pip --no-cache-dir install pipenv && \
  : "set cache dir for pipenv" && \
  mkdir -p /.cache && \
  chmod 777 /.cache
ENV PIPENV_VENV_IN_PROJECT=1

RUN set -x \
  && : "create home directory for all user" \
  && mkdir -p /home/dev \
  && chmod 777 /home/dev

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash \
  HOME=/home/dev
CMD ["python"]
