FROM google/cloud-sdk:232.0.0-slim
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
ENV GOSU_VERSION=1.11
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
  git clone --depth=1 -b v0.2.0 https://github.com/iimuz/dotfiles.git ${HOME}/.dotfiles && \
  echo "\nif [ -f ~/.config/bash/xdg-base.sh ]; then\n  . ~/.config/bash/xdg-base.sh\nfi\n" >> ${HOME}/.bashrc && \
  mkdir -p ${HOME}/.config/bash && \
  mv ${HOME}/.dotfiles/.config/bash/xdg-base.sh ${HOME}/.config/bash/xdg-base.sh && \
  mv ${HOME}/.dotfiles/.inputrc ${HOME}/ && \
  # gcp aliases
  echo "\nif [ -f ~/.config/bash/gcp-alias.sh ]; then\n  . ~/.config/bash/gcp-alias.sh\nfi\n" >> ${HOME}/.bashrc && \
  echo "alias gscp='gcloud compute scp'" >> ${HOME}/.config/bash/gcp-alias.sh && \
  echo "alias glist='gcloud compute instances list'" >> ${HOME}/.config/bash/gcp-alias.sh && \
  echo "alias gssh='gcloud compute ssh'" >> ${HOME}/.config/bash/gcp-alias.sh && \
  echo "alias gup='gcloud compute instances start'" >> ${HOME}/.config/bash/gcp-alias.sh && \
  echo "alias gdown='gcloud compute instances stop'" >> ${HOME}/.config/bash/gcp-alias.sh && \
  # cloud functions emulator
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt install -y --no-install-recommends nodejs && \
  nodejs -v && \
  npm -v && \
  npm install -g @google-cloud/functions-emulator && \
  # cleanup
  apt-get purge -y $fetchDeps && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get autoremove -y && \
  rm -rf ${HOME}/.dotfiles && \
  chown -R ${USER_NAME}:${USER_NAME} $HOME

ENV SOURCE_DIR=/src
RUN set -x && \
  mkdir -p $SOURCE_DIR

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR $SOURCE_DIR
VOLUME ["/home/gcloud/.config"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["gcloud"]
