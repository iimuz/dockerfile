FROM golang:1.9.2
LABEL maintainer iimuz

ENV binpath=/usr/local/bin

# ghq
ENV GHQ_VERSION=v0.8.0
RUN mkdir -p /go/src/github.com/motemen/ghq && cd /go/src/github.com/motemen \
  && git clone --depth=1 -b ${GHQ_VERSION} https://github.com/motemen/ghq.git ./ghq && cd ./ghq \
  && make build \
  && mv ./ghq ${binpath} \
  && git config --global ghq.root /go/src \
  && cd ~ \
  && rm -rf /go/src/* /go/bin/*

# dep
ENV DEP_VERSION=v0.3.2
RUN mkdir -p /go/src/github.com/golang/dep && cd /go/src/github.com/golang \
  && git clone --depth=1 -b ${DEP_VERSION} https://github.com/golang/dep.git ./dep && cd ./dep \
  && go build -o dep ./cmd/dep \
  && mv ./dep ${binpath} \
  && cd ~ \
  && rm -rf /go/src/* /go/bin/*

# glide(deprecated)
ENV GLIDE_VERSION=v0.13.1
RUN mkdir -p /go/src/github.com/Masterminds/glide && cd /go/src/github.com/Masterminds \
  && git clone --depth=1 -b ${GLIDE_VERSION} https://github.com/Masterminds/glide.git ./glide && cd ./glide \
  && make build \
  && mv ./glide ${binpath} \
  && cd ~ \
  && rm -rf /go/src/* /go/bin/*

# swig
ENV SWIG_VERSION=rel-3.0.12
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    libtool \
  && apt-get install -y --no-install-recommends \
    libpcre3-dev \
  && apt-get install -y --no-install-recommends \
    bison \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /go/src/github.com/swig/swig && cd /go/src/github.com/swig \
  && git clone --depth=1 -b ${SWIG_VERSION} https://github.com/swig/swig.git ./swig && cd ./swig \
  && sh autogen.sh \
  && ./configure \
  && make \
  && make install \
  && cd ~ \
  && rm -rf /go/src/* /go/bin/*

# tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    && tmux \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# vim
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    gcc \
    libc-dev \
    locales \
    make \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=en_US.UTF-8 \
  && go get github.com/golang/lint/golint \
  && go get github.com/jstemmer/gotags \
  && go get github.com/kisielk/errcheck \
  && go get github.com/nsf/gocode \
  && go get github.com/rogpeppe/godef \
  && go get github.com/tools/godep \
  && go get golang.org/x/tools/cmd/godoc \
  && go get golang.org/x/tools/cmd/goimports \
  && go get golang.org/x/tools/cmd/gorename \
  && go get golang.org/x/tools/cmd/guru \
  && mv /go/bin/* ${binpath} \
  && rm -rf /go/bin/* /go/pkg/* /go/src/*

# add dev user
ENV HOME /home/dev
COPY ./home $HOME
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev /go $HOME
USER dev
ENV LANG en_US.UTF-8

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh \
  && sh $HOME/installer.sh $HOME/.cache/dein \
  && rm $HOME/installer.sh \
  && vim +":silent! call dein#install()" +qall

WORKDIR /go

