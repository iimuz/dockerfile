FROM golang:1.9.1
LABEL maintainer iimuz

arg binpath=/usr/local/bin

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
  && apt-get install -y \
    autoconf \
    automake \
    libtool \
  && apt-get install -y \
    libpcre3-dev \
  && apt-get install -y \
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

