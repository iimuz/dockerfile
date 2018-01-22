FROM iimuz/cpp-dev:v1.1.1
LABEL maintainer iimuz

USER root

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    pkg-config && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN cd /opt && \
  git clone --recursive --depth 1 -b boost-1.66.0 https://github.com/boostorg/boost.git && \
  cd /opt/boost && \
  sh bootstrap.sh \
    --with-toolset=clang && \
  ./b2 -j$(grep processor /proc/cpuinfo | wc -l) \
    --toolset=clang \
    install \
    --libdir=/usr/local/lib \
    --without-python && \
  ./b2 -j$(grep processor /proc/cpuinfo | wc -l) \
    --toolset=clang \
    install \
    --libdir=/usr/local/lib \
    --includedir=/usr/local/include \
    --without-python && \
  ./b2 tools/boostdep/build && \
  ./dist/bin/boostdep --list-modules | xargs -IXX sh -c \
    './dist/bin/boostdep --pkgconfig XX 1.6.3 prefix=/usr/local includedir='${prefix}/include' libdir='${prefix}/lib' > /usr/lib/x86_64-linux-gnu/pkgconfig/boost_XX.pc' && \
  cd /opt && \
  rm -rf boost && \
  ldconfig

USER dev

