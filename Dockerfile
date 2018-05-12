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

# gosu
ENV GOSU_VERSION=1.10
RUN fetchDeps=' \
    ca-certificates \
    wget \
  ' && \
  apt-get update && \
  apt-get install -y --no-install-recommends $fetchDeps && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get autoremove -y

ENV USER_NAME=gcloud \
  HOME=/home/gcloud \
  USER_ID=1000 \
  GROUP_ID=1000 \
  GHQ_VERSION=0.8.0 \
  TERRAFORM_VERSION=0.11.7
RUN adduser ${USER_NAME} --disabled-password --gecos "" && \
  fetchDeps=' \
    ca-certificates \
    curl \
    git \
    unzip \
    wget \
  ' && \
  apt-get update && \
  apt-get install -y --no-install-recommends $fetchDeps && \
  # bash
  git clone --depth=1 https://github.com/iimuz/dotfiles.git ${HOME}/.dotfiles && \
  echo "\nif [ -f ~/.bashrc.local ]; then\n  . ~/.bashrc.local\nfi\n" >> ${HOME}/.bashrc && \
  mv ${HOME}/.dotfiles/.bashrc ${HOME}/.bashrc.local && \
  mv ${HOME}/.dotfiles/.inputrc ${HOME}/ && \
  # terraform
  curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  mv terraform /usr/bin/ && \
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  # gcp aliases
  echo "alias gscp='gcloud compute scp'" >> ${HOME}/.bashrc.local && \
  echo "alias glist='gcloud compute instances list'" >> ${HOME}/.bashrc.local && \
  echo "alias gssh='gcloud compute ssh'" >> ${HOME}/.bashrc.local && \
  echo "alias gup='gcloud compute instances start'" >> ${HOME}/.bashrc.local && \
  echo "alias gdown='gcloud compute instances stop'" >> ${HOME}/.bashrc.local && \
  # cleanup
  apt-get purge -y $fetchDeps && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get autoremove -y && \
  rm -rf ${HOME}/.dotfiles && \
  # for volumes
  mkdir ${HOME}/src ${HOME}/pkg ${HOME}/bin

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
