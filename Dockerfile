FROM golang:1.7.4
MAINTAINER iimuz

ENV SWIG_VERSION 3.0.11
ENV SWIG_DOWNLOAD_PATH https://github.com/swig/swig/archive
ENV SWIG_ARCHIVE rel-${SWIG_VERSION}

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

ADD ${SWIG_DOWNLOAD_PATH}/${SWIG_ARCHIVE}.tar.gz ./
RUN tar xzvf ./${SWIG_ARCHIVE}.tar.gz \
    && cd ./swig-${SWIG_ARCHIVE} \
    && sh autogen.sh \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm ./${SWIG_ARCHIVE}.tar.gz
    && rm -r ./swig-${SWIG_ARCHIVE}

