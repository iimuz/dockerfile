FROM debian:9.4
LABEL maintainer "iimuz"

# add user
ENV HOME /home/dev
RUN adduser dev --disabled-password --gecos ""

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

# tools for development
ENV GHQ_VERSION=0.8.0 \
  GOSU_VERSION=1.10
RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    make \
    wget && \
  # gosu
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  # git
  apt install -y --no-install-recommends git ssh && \
  gosu dev git clone --depth=1 https://github.com/iimuz/dotfiles.git ${HOME}/.dotfiles && \
  gosu dev mv ~/.dotfiles/.gitconfig ~/ && \
  # bash
  gosu dev echo -e "\nif [ -f ~/.bashrc.local ]; then\n  . ~/.bashrc.local\nfi\n" >> ~/.bashrc && \
  gosu dev mv ~/.dotfiles/.bashrc ~/.bashrc.local && \
  gosu dev mv ~/.dotfiles/.inputrc ~/ && \
  # neovim
  apt install -y --no-install-recommends neovim && \
  gosu dev mkdir -p ${HOME}/.config/nvim && \
  gosu dev mv ~/.dotfiles/.vimrc ~/.config/nvim/init.vim && \
  # tmux
  apt install -y --no-install-recommends tmux && \
  gosu dev mv ~/.dotfiles/.tmux.conf ~/ && \
  # ghq
  apt install -y --no-install-recommends unzip && \
  wget https://github.com/motemen/ghq/releases/download/v${GHQ_VERSION}/ghq_linux_amd64.zip && \
  unzip ghq_linux_amd64.zip -d ghq && \
  mv ghq/ghq /usr/bin/ && \
  rm -rf ghq ghq_linux_amd64.zip && \
  gosu dev echo -e "\n[ghq]\n  root = ~/src\n" >> ~/.gitconfig.local && \
  # fzf
  gosu dev git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  gosu dev bash -c "yes | ~/.fzf/install" && \
  gosu dev rm -rf ~/.fzf/.git && \
  # krypt.co
  wget https://krypt.co/kr -O ./kr && \
  sed -i -e 's/sudo apt-get/apt-get/g' kr && \
  sed -i -e 's/sudo apt-key/apt-key/g' kr && \
  sed -i -e 's/sudo add-apt-repository/add-apt-repository/g' kr && \
  sh kr || sh kr \
  rm kr && \
  # cleanup
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y && \
  rm -rf ${HOME}/.dotfiles && \
  # for named volume
  gosu dev mkdir ~/src && \
  # change permission
  chown -R dev:dev /home/dev

USER dev
WORKDIR ${HOME}
CMD ["bash"]
