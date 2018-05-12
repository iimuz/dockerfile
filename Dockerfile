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

ENV HOME=/home/dev \
  GHQ_VERSION=0.8.0 \
  TERRAFORM_VERSION=0.11.7
RUN adduser dev --disabled-password --gecos "" && \
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
  # for named volume
  mkdir ${HOME}/src && \
  mkdir ${HOME}/pkg && \
  mkdir ${HOME}/bin && \
  # change permission
  chown -R dev:dev /home/dev

USER dev
WORKDIR ${HOME}
CMD ["bash"]
