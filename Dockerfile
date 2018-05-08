FROM debian:9.4
LABEL maintainer iimuz

# set locale
RUN apt update && apt install -y --no-install-recommends \
    apt-utils \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# install memo
ENV MEMO_VER=v0.0.4 \
  MEMO_ARCHIVE=memo_linux_amd64.zip
RUN fetchDeps=' \
    ca-certificates \
    unzip \
    wget \
  ' && \
  apt update && \
  apt install -y --no-install-recommends $fetchDeps && \
  wget https://github.com/mattn/memo/releases/download/${MEMO_VER}/${MEMO_ARCHIVE} && \
  unzip ${MEMO_ARCHIVE} && \
  mv memo /usr/bin/ && \
  rm ${MEMO_ARCHIVE} && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt purge -y --auto-remove $fetchDeps

# install tools and settings
ENV HOME=/home/dev
COPY config.toml /home/dev/.config/memo/config.toml
RUN adduser dev --disabled-password --gecos "" && \
  apt update && \
  apt install -y --no-install-recommends \
    neovim \
    peco && \
  fetchDeps=' \
    ca-certificates \
    git \
    wget \
  ' && \
  apt install -y --no-install-recommends $fetchDeps && \
  # memo settings
  mkdir -p ${HOME}/.config/memo/_posts && \
  # get settings
  git clone --depth=1 https://github.com/iimuz/dotfiles.git ${HOME}/dotfiles && \
  # neovim settings
  mkdir -p ${HOME}/.config/nvim && \
  mv ${HOME}/dotfiles/.vimrc ~/.config/nvim/init.vim && \
  # cleanup
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt purge -y --auto-remove $fetchDeps && \
  apt autoremote -y && \
  rm -rf ${HOME}/dotfiles && \
  # permission
  chown -R dev:dev /home/dev

USER dev
WORKDIR /home/dev
CMD ["memo"]
