FROM alpine:3.8
LABEL maintainer iimuz

# locale and timezone
ENV LANG="ja_JP.UTF-8" \
  LANGUAGE="ja_JP:ja" \
  LC_ALL="ja_JP.UTF-8"
RUN set -x && \
  apk update && \
  apk add --no-cache tzdata && \
  rm -rf /var/cache/apk/*

# add user
ENV USER_NAME=git \
  HOME=/home/git \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  apk update && \
  apk add --no-cache su-exec shadow && \
  rm -rf /var/cache/apk/* && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# tools
ENV ENV=${HOME}/.profile
RUN set -x && \
  fetchDeps=' \
    unzip \
  ' && \
  apk update && \
  apk add --no-cache \
    ca-certificates \
    diffutils \
    git \
    less \
    netcat-openbsd \
    openssh && \
  apk add --no-cache $fetchDeps && \
  : "ssh" && \
  mkdir ~/.ssh && \
  : "git" && \
  git clone --depth=1 -b develop https://github.com/iimuz/dotfiles.git ${HOME}/dotfiles && \
  mv ~/dotfiles/.gitconfig ${HOME}/ && \
  sed -i -e "s/~\/src/\/src/g" $HOME/.gitconfig && \
  : "neovim" && \
  apk add --no-cache neovim && \
  ln -s /usr/bin/nvim /usr/bin/vim && \
  mkdir -p ~/.config/nvim && \
  mv ~/dotfiles/.config/nvim/init.vim ~/.config/nvim/ && \
  : "ghq" && \
  GHQ_SCRIPT=$HOME/dotfiles/scripts/ghq.sh && \
  sed -i -e "s/sudo //g" $GHQ_SCRIPT && \
  sed -i -e "s/GHQ_ROOT=~/GHQ_ROOT=/g" $GHQ_SCRIPT && \
  sh $GHQ_SCRIPT && \
  : "peco" && \
  PECO_SCRIPT=$HOME/dotfiles/scripts/peco.sh && \
  sed -i -e "s/sudo //g" $PECO_SCRIPT && \
  sed -i -e "s/BASHRC_MAIN=~\/.bashrc/BASHRC_MAIN=~\/.profile/g" $PECO_SCRIPT && \
  sed -i -e "s/alias.inc/alias.ash.inc/g" $PECO_SCRIPT && \
  sed -i -e "s/ln -s/cp/g" $PECO_SCRIPT && \
  sh $PECO_SCRIPT && \
  : "clean" && \
  chown -R ${USER_NAME}:${USER_NAME} ${HOME} && \
  rm -rf ${HOME}/dotfiles && \
  apk del --purge $fetchDeps && \
  rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ash"]
