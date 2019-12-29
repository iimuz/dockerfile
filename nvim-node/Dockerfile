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
  && : "install eslint" \
  && npm install -g \
    babel-eslint \
    eslint \
    eslint-plugin-import \
    eslint-plugin-jsx-a11y \
    eslint-plugin-vue \
    eslint-plugin-react \
    eslint-config-airbnb \
    @typescript-eslint/parser \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY .eslintrc /.eslintrc

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x \
  && : "install plugins" \
  && nvim +"call dein#install()" +qall \
  && nvim +"UpdateRemotePlugins" +qall \
  && : "setting for normal user" \
  && chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

