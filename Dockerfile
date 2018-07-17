FROM alpine:3.8
LABEL maintainer iimuz

# language and locale
ENV LANG="ja_JP.UTF-8" \
  LANGUAGE="ja_JP:ja" \
  LC_ALL="ja_JP.UTF-8"

# add user
ENV USER_NAME=nvim \
  HOME=/home/nvim \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  apk update && \
  apk add --no-cache su-exec shadow && \
  rm -rf /var/cache/apk/* && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# neovim
ENV NEOVIM_VERSION=0.3.0-r0
RUN set -x && \
  apk update && \
  apk add --no-cache --virtual .build-deps \
    gcc \
    linux-headers \
    musl-dev && \
  apk add --no-cache \
    neovim=${NEOVIM_VERSION} \
    python-dev \
    py-pip \
    python3-dev \
    py3-pip && \
  pip install --no-cache setuptools && \
  pip install --no-cache neovim==0.2.6 && \
  pip3 install --no-cache setuptools && \
  pip3 install --no-cache neovim==0.2.6 && \
  apk del .build-deps && \
  rm -rf /var/cache/apk/*

COPY .vim /opt/.vim
RUN set -x && \
  apk update && \
  apk add --no-cache git && \
  apk add --no-cache --virtual .fetch-deps curl && \
  : "get settings" && \
  su-exec ${USER_NAME} git clone --depth=1 -b v0.1.0 https://github.com/iimuz/dotfiles.git ${HOME}/dotfiles && \
  : "neovim settings" && \
  su-exec ${USER_NAME} mkdir -p ${HOME}/.config/nvim && \
  su-exec ${USER_NAME} mv ${HOME}/dotfiles/.config/nvim/init.vim ${HOME}/.config/nvim/ && \
  : "dein" && \
  su-exec ${USER_NAME} mv ${HOME}/dotfiles/.config/nvim/dein.vim ${HOME}/.config/nvim/ && \
  su-exec ${USER_NAME} sed -i -e 's/~\/.cache\/dein/\/opt\/.cache\/dein/' ${HOME}/.config/nvim/dein.vim && \
  su-exec ${USER_NAME} sed -i -e 's/~\/.vim\/rc/\/opt\/.vim\/rc/' ${HOME}/.config/nvim/dein.vim && \
  su-exec ${USER_NAME} curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${HOME}/installer.sh && \
  chown -R ${USER_NAME}:${USER_GROUP} /opt && \
  su-exec ${USER_NAME} sh ${HOME}/installer.sh /opt/.cache/dein && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall && \
  chmod -R 777 /opt/.vim /opt/.cache && \
  : "cleanup" && \
  rm ${HOME}/installer.sh && \
  rm -rf ${HOME}/dotfiles && \
  apk del .fetch-deps && \
  rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nvim"]
