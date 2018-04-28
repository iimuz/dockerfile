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

# tools for development
RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    neovim \
    peco \
    ssh \
    tmux \
    unzip \
    wget && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  # ghq
  wget https://github.com/motemen/ghq/releases/download/v0.8.0/ghq_linux_amd64.zip && \
  unzip ghq_linux_amd64.zip -d ghq && \
  mv ghq/ghq /usr/bin/ && \
  rm -rf ghq ghq_linux_amd64.zip .wget-hsts && \
  # krypt
  apt update && \
  wget https://krypt.co/kr -O ./kr && \
  sed -i -e 's/sudo apt-get/apt-get/g' kr && \
  sed -i -e 's/sudo apt-key/apt-key/g' kr && \
  sed -i -e 's/sudo add-apt-repository/add-apt-repository/g' kr && \
  sh kr && \
  rm kr && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

# add dev user
ENV HOME /home/dev
RUN adduser dev --disabled-password --gecos "" && \
  echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir -p ${HOME}/.config/nvim && \
  chown -R dev:dev /home/dev
USER dev

# set config
RUN echo "\nif [ -f ~/.bashrc.local ]; then\n  . ~/.bashrc.local\nfi\n" >> ~/.bashrc && \
  wget https://raw.githubusercontent.com/iimuz/dotfiles/master/.bashrc -O ~/.bashrc.local && \
  wget https://raw.githubusercontent.com/iimuz/dotfiles/master/.gitconfig -O ~/.gitconfig && \
  wget https://raw.githubusercontent.com/iimuz/dotfiles/master/.tmux.conf -O ~/.tmux.conf && \
  wget https://raw.githubusercontent.com/iimuz/dotfiles/master/.inputrc -O ~/.inputrc && \
  wget https://raw.githubusercontent.com/iimuz/dotfiles/master/.vimrc -O ~/.config/nvim/init.vim && \
  echo "\n[ghq]\n  root = ~/src\n" >> ~/.gitconfig.local

WORKDIR ${HOME}
