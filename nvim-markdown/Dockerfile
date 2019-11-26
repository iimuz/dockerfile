FROM iimuz/neovim:v0.4.3-1
LABEL maintainer iimuz

RUN set -x \
  && : "install packages" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ctags \
    git \
    vim-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "add packages for build" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    make \
  && : "install plugins" \
  && nvim +"silent! call dein#install()" +qall \
  && nvim +"UpdateRemotePlugin" +qall \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME \
  && : "clean" \
  && apt-get remove -y make \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

