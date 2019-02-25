FROM localhost:nvim
LABEL maintainer iimuz

RUN set -x && \
  apk add --no-cache nodejs nodejs-npm && \
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
COPY .eslintrc ${HOME}/.eslintrc

COPY .config/nvim/* $XDG_CONFIG_HOME/nvim/
RUN set -x && \
  : "install plugins" && \
  nvim +"call dein#install()" +qall && \
  nvim +"UpdateRemotePlugin" +qall && \
  : "setting for normal user" && \
  chmod -R 777 $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

