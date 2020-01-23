FROM iimuz/neovim:v0.4.3-2
LABEL maintainer iimuz

RUN set -x \
  && : "install packages" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ctags \
    git \
    nodejs \
    npm \
    vim-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "install plugins" \
  && nvim +"call dein#install()" +qall \
  && nvim +"UpdateRemotePlugins" +qall \
  && export COC_EXTENSION_DIR=$HOME/.config/coc/extensions \
  && : "Install coc extensions" \
  && mkdir -p $COC_EXTENSION_DIR \
  && cd $COC_EXTENSION_DIR \
  && yarn add coc-css \
  && nvim +"CocInstall coc-css" +qall \
  && yarn add coc-html \
  && nvim +"CocInstall coc-html" +qall \
  && yarn add coc-json \
  && nvim +"CocInstall coc-json" +qall \
  && yarn add coc-tsserver \
  && nvim +"CocInstall coc-tsserver" +qall \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

