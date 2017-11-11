FROM golang:1.9.1
LABEL maintainer iimuz

arg binpath=/usr/local/bin

arg ghq_version=v0.8.0
arg ghq_download_path=https://github.com/motemen/ghq.git
arg ghq_local_path=/go/src/github.com/motemen/ghq 
RUN git clone --depth=1 -b ${ghq_version} ${ghq_download_path} ${ghq_local_path} \
  && cd ${ghq_local_path} \
  && make build \
  && mv ./ghq ${binpath} \
  && git config --global ghq.root /go/src \
  && cd ~ \
  && rm -rf /go/src/* /go/bin/*

arg glide_version=v0.13.1
arg glide_download_path=Masterminds/glide
arg glide_local_path=/go/src/github.com/${glide_download_path}
RUN ghq get ${glide_download_path} \
  && cd ${glide_local_path} \
  && git checkout refs/tags/${glide_version} \
  && make build \
  && mv ./glide ${binpath} \
  && cd ~ \
  && rm -rf /go/src/* /go/bin/*

arg swig_version=rel-3.0.12
arg swig_download_path=swig/swig
arg swig_local_path=/go/src/github.com/${swig_download_path}
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
RUN ghq get ${swig_download_path} \
  && cd ${swig_local_path} \
  && git checkout refs/tags/${swig_version} \
  && sh autogen.sh \
  && ./configure \
  && make \
  && make install \
  && cd ~ \
  && rm -rf /go/src/* /go/bin/*

