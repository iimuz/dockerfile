FROM google/cloud-sdk:198.0.0
LABEL maintainer "iimuz"

# set locale
RUN apt-get update && apt install -y --no-install-recommends \
    apt-utils \
    locales && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# set tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    vim \
    ssh \
    unzip \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # peco
  wget https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_amd64.tar.gz && \
  tar xvzf peco_linux_amd64.tar.gz && \
  mv peco_linux_amd64/peco /usr/bin/ && \
  rm -rf peco_linux_amd64 peco_linux_amd64.tar.gz && \
  # ghq
  wget https://github.com/motemen/ghq/releases/download/v0.8.0/ghq_linux_amd64.zip && \
  unzip ghq_linux_amd64.zip -d ghq && \
  mv ghq/ghq /usr/bin/ && \
  rm -rf ghq ghq_linux_amd64.zip .wget-hsts && \
  # terraform
  curl https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -O && \
  unzip terraform_0.11.7_linux_amd64.zip && \
  mv terraform /usr/bin/ && \
  rm terraform_0.11.7_linux_amd64.zip

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
  echo "\n[ghq]\n  root = ~/src\n" >> ~/.gitconfig.local && \
  echo "alias gscp='gcloud compute scp'" >> ~/.bashrc.local && \
  echo "alias glist='gcloud compute instances list'" >> ~/.bashrc.local && \
  echo "alias gssh='gcloud compute ssh'" >> ~/.bashrc.local && \
  echo "alias gup='gcloud compute instances start'" >> ~/.bashrc.local && \
  echo "alias gdown='gcloud compute instances stop'" >> ~/.bashrc.local

WORKDIR ${HOME}
