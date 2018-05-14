FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build
LABEL maintainer iimuz

RUN go get github.com/mattn/memo

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

# add user
ENV USER_NAME=memo \
  HOME=/home/memo \
  USER_ID=1000 \
  GROUP_ID=1000
RUN adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# memo
COPY --from=build /go/bin/memo /usr/bin/

# install tools and settings
COPY config.toml /home/dev/.config/memo/config.toml
RUN apt update && \
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
  apt purge -y --auto-remove $fetchDeps && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf ${HOME}/dotfiles

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["memo"]
