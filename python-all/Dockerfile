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

RUN set -x \
  && : "Install packages for mssql" \
  && apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17 \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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
  && apt-get install -y --no-install-recommends \
    curl \
    git \
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
  && : "Install poetry" \
  && apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | $CMD_PYTHON \
  && poetry config --list \
  && poetry config virtualenvs.create true \
  && poetry config virtualenvs.in-project true \
  && : "Clean" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY .bashrc $HOME/.bashrc

RUN set -x \
  && : "Install node" \
  && nodeVersion="13.12.0" \
  && nodeArch="x64" \
  && yarnVersion="1.22.4" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$nodeVersion/node-v$nodeVersion-linux-$nodeArch.tar.xz" \
  && tar -xJf "node-v$nodeVersion-linux-$nodeArch.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$nodeVersion-linux-$nodeArch.tar.xz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && : "Install yarn" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$yarnVersion/yarn-v$yarnVersion.tar.gz" \
  && mkdir -p /opt \
  && tar -xzf yarn-v$yarnVersion.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$yarnVersion/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$yarnVersion/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$yarnVersion.tar.gz \
  && : "smoke test" \
  && node --version \
  && npm --version \
  && yarn --version

RUN set -x \
  && : "Set directory permission" \
  && chmod -R 777 $HOME

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash
CMD ["python"]
