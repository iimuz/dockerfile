FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
LABEL maintainer "iimuz"

ENV HOME=/home/dev
ENV XDG_CACHE_HOME=$HOME/.cache \
  XDG_CONFIG_DIRS=$HOME/etc/xdg \
  XDG_CONFIG_HOME=$HOME/.config \
  XDG_DATA_DIRS=/usr/local/share:/usr/share \
  XDG_DATA_HOME=$HOME/.local/share
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && : "create home directory for all user" \
  && mkdir -p $HOME \
  && chmod 777 $HOME

ENV CMD_PYTHON=python3.7
RUN set -x \
  && : "Install python" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    $CMD_PYTHON \
    ${CMD_PYTHON}-dev \
    ${CMD_PYTHON}-distutils \
    ${CMD_PYTHON}-venv \
  && : "Set default python" \
  && default_python=/usr/bin/python \
  && if [ -L $default_python ]; then unlink $default_python; fi \
  && ln -s /usr/bin/$CMD_PYTHON $default_python \
  && : "Set default python3" \
  && default_python3=/usr/bin/python3 \
  && if [ -L $default_python3 ]; then unlink $default_python3; fi \
  && ln -s /usr/bin/$CMD_PYTHON $default_python3

RUN set -x \
  && : "Install development tools" \
  && apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && : "Install pip" \
  && curl -sSL https://bootstrap.pypa.io/get-pip.py | $CMD_PYTHON

RUN set -x \
  && : "install pipenv" \
  && pip --no-cache-dir install pipenv \
  && : "set cache dir for pipenv" \
  && mkdir -p /.cache \
  && chmod 777 /.cache
ENV PIPENV_VENV_IN_PROJECT=1

ENV PATH=$PATH:$HOME/.poetry/bin
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && : "Install poetry" \
  && curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | $CMD_PYTHON \
  && poetry config --list \
  && poetry config virtualenvs.create true \
  && poetry config virtualenvs.in-project true \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY .bashrc $HOME/.bashrc

RUN set -x \
  && : "Set directory permission" \
  && chmod -R 777 $HOME

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash
CMD ["python"]
