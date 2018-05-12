FROM debian:9.4
LABEL maintainer "iimuz"

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

# gosu
ENV GOSU_VERSION=1.10
RUN fetchDeps=' \
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

# tools for development
ENV USER_NAME=dev \
  HOME=/home/dev \
  USER_ID=1000 \
  GROUP_ID=1000 \
  GHQ_VERSION=0.8.0
RUN adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos "" && \
  fetchDeps=' \
    curl \
    wget \
  ' && \
  apt update && \
  apt install -y --no-install-recommends $fetchDeps && \
  # ssh
  apt install -y --no-install-recommends ssh && \
  # git
  apt install -y --no-install-recommends ca-certificates git && \
  git clone --depth=1 https://github.com/iimuz/dotfiles.git ${HOME}/.dotfiles && \
  mv ${HOME}/.dotfiles/.gitconfig ${HOME}/ && \
  # bash
  echo "\nif [ -f ~/.bashrc.local ]; then\n  . ~/.bashrc.local\nfi\n" >> ${HOME}/.bashrc && \
  mv ${HOME}/.dotfiles/.bashrc ${HOME}/.bashrc.local && \
  mv ${HOME}/.dotfiles/.inputrc ${HOME}/ && \
  # neovim
  apt install -y --no-install-recommends neovim && \
  mkdir -p ${HOME}/.config/nvim && \
  mv ${HOME}/.dotfiles/.vimrc ${HOME}/.config/nvim/init.vim && \
  # ghq
  apt install -y --no-install-recommends unzip && \
  wget https://github.com/motemen/ghq/releases/download/v${GHQ_VERSION}/ghq_linux_amd64.zip && \
  unzip ghq_linux_amd64.zip -d ghq && \
  mv ghq/ghq /usr/bin/ && \
  rm -rf ghq ghq_linux_amd64.zip && \
  echo "\n[ghq]\n  root = ~/src\n" >> ${HOME}/.gitconfig.local && \
  # fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf && \
  bash -c "yes | ${HOME}/.fzf/install" && \
  rm -rf ${HOME}/.fzf/.git && \
  # krypt.co
  wget https://krypt.co/kr -O ./kr && \
  sed -i -e 's/sudo apt-get/apt-get/g' ./kr && \
  sed -i -e 's/sudo apt-key/apt-key/g' ./kr && \
  sed -i -e 's/sudo add-apt-repository/add-apt-repository/g' ./kr && \
  sh ./kr || sh /kr \
  rm ./kr && \
  # cleanup
  apt purge -y --autoremove $fetchDeps && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y && \
  rm -rf ${HOME}/.dotfiles && \
  rm ${HOME}/.wget-hsts && \
  # for volumes
  mkdir ${HOME}/src ${HOME}/pkg ${HOME}/bin

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
