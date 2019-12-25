FROM iimuz/neovim:v0.4.3-1
LABEL maintainer iimuz

RUN set -x \
  && : "install packages" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ctags \
    git \
    vim-common \
  && pip3 install --no-cache pipenv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "install plugins" \
  && nvim +"call dein#install()" +qall \
  && nvim +"UpdateRemotePlugin" +qall \
  && export COC_EXTENSION_DIR=$HOME/.config/coc/extensions \
  && : "Install coc extensions" \
  && mkdir -p $COC_EXTENSION_DIR \
  && cd $COC_EXTENSION_DIR \
  && yarn add coc-python \
  && nvim +"CocInstall coc-python" +qall \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

