FROM debian:9.4
LABEL maintainer iimuz

# set locale
RUN set -x && \
  apt update && apt-get install -y --no-install-recommends \
    apt-utils \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# gosu
ENV GOSU_VERSION=1.10
RUN set -x && \
  fetchDeps=' \
    ca-certificates \
    wget \
  ' && \
  apt update && \
  apt install -y --no-install-recommends $fetchDeps && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y

# add user
ENV USER_NAME=nvim \
  HOME=/home/nvim \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# neovim
ENV NEOVIM_VERSION=0.3.0-2
COPY .vim /opt/.vim
RUN set -x && \
  echo "deb http://ftp.debian.org/debian unstable main" >> /etc/apt/sources.list && \
  apt update && \
  apt -t unstable install -y --no-install-recommends \
    neovim=${NEOVIM_VERSION} \
    python-neovim \
    python-pip \
    python3-neovim \
    python3-pip && \
  pip install --no-cache setuptools && \
  pip install --no-cache neovim==0.2.6 && \
  pip3 install --no-cache setuptools && \
  pip3 install --no-cache neovim==0.2.6 && \
  : "dein requirements" && \
  apt install -y --no-install-recommends \
    ca-certificates \
    git && \
  : "temp packages" && \
  fetchDeps=' \
    curl \
  ' && \
  apt install -y --no-install-recommends $fetchDeps && \
  : "get settings" && \
  git clone --depth=1 -b v0.1.0 https://github.com/iimuz/dotfiles.git ${HOME}/dotfiles && \
  : "neovim settings" && \
  mkdir -p ${HOME}/.config/nvim && \
  mv ${HOME}/dotfiles/.config/nvim/init.vim ~/.config/nvim/ && \
  mv ${HOME}/dotfiles/.config/nvim/dein.vim ~/.config/nvim/ && \
  sed -i -e 's/~\/.cache\/dein/\/opt\/.cache\/dein/' ~/.config/nvim/dein.vim && \
  sed -i -e 's/~\/.vim\/rc/\/opt\/.vim\/rc/' ~/.config/nvim/dein.vim && \
  curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh && \
  chown -R ${USER_NAME}:${USER_NAME} ${HOME} && \
  mkdir -p /opt/.cache/dein && \
  chmod -R 777 /opt/.cache && \
  chmod -R 777 /opt/.vim && \
  gosu ${USER_NAME} sh ${HOME}/installer.sh /opt/.cache/dein && \
  rm ${HOME}/installer.sh && \
  gosu ${USER_NAME} nvim +":silent! call dein#install()" +qall && \
  chmod -R 777 /opt/.cache && \
  chmod -R 777 /opt/.vim && \
  : "cleanup" && \
  apt purge -y $fetchDeps && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf ${HOME}/dotfiles

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nvim"]

