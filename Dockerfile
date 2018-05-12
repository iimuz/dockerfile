FROM golang:1.10.2-stretch
LABEL maintainer iimuz

# set locale
RUN apt update && apt install -y --no-install-recommends \
    apt-utils \
    locales && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8 && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*
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
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

# tools for go lang
RUN go get github.com/golang/dep/cmd/dep && \
  go get github.com/golang/lint/golint && \
  go get github.com/jstemmer/gotags && \
  go get github.com/kisielk/errcheck && \
  go get github.com/Masterminds/glide && \
  go get github.com/motemen/ghq && \
  go get github.com/nsf/gocode && \
  go get github.com/rogpeppe/godef && \
  go get github.com/tools/godep && \
  go get golang.org/x/tools/cmd/godoc && \
  go get golang.org/x/tools/cmd/goimports && \
  go get golang.org/x/tools/cmd/gorename && \
  go get golang.org/x/tools/cmd/guru && \
  mv /go/bin/* /usr/local/bin/ && \
  rm -rf /go/bin/* /go/pkg/* /go/src/*

# tools for bash
ENV USER_NAME=go \
  HOME=/home/go \
  USER_ID=1000 \
  GROUP_ID=1000
RUN adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# neovim
RUN echo 'APT::Default-Release "unstable";' >> /etc/apt/apt.conf.d/99target && \
  cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
  echo 'deb http://ftp.jp.debian.org/debian unstable main contrib non-free' >> /etc/apt/sources.list && \
  echo 'deb-src http://ftp.jp.debian.org/debian unstable main contrib non-free' >> /etc/apt/sources.list && \
  apt update && \
  apt install -y --no-install-recommends neovim python-neovim python3-neovim && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm /etc/apt/apt.conf.d/99target && \
  mv /etc/apt/sources.list.bak /etc/apt/sources.list && \
  # install plugins
  mkdir -p ${HOME}/.cache/dein && \
  curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh && \
  sh $HOME/installer.sh $HOME/.cache/dein && \
  rm $HOME/installer.sh && \
  nvim +":silent! call dein#install()" +qall

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR /go
ENTRYPOINT ["/entrypoint.sh"]
CMD ["go"]
