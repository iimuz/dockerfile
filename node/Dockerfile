FROM iimuz/neovim:v0.3.1-1
LABEL maintainer iimuz

RUN set -x && \
  : "install packages" && \
  apk update && \
  apk add --no-cache \
    ctags=5.8-r5 \
    git=2.20.1-r0 \
    nodejs=10.14.2-r0 \
    npm=10.14.2-r0 \
    vimdiff=8.1.0630-r0 && \
  : "install eslint" && \
  npm install -g \
    babel-eslint@10.0.1 \
    eslint@5.14.1 \
    eslint-plugin-import@2.16.0 \
    eslint-plugin-jsx-a11y@6.2.1 \
    eslint-plugin-vue@5.2.2 \
    eslint-plugin-react@7.12.4 \
    eslint-config-airbnb@17.1.0 \
    @typescript-eslint/parser@1.4.1 && \
  rm -rf /var/cache/apk/*
COPY .eslintrc /.eslintrc

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "install plugins" && \
  nvim +"call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

