FROM buildpack-deps:stretch-scm
LABEL maintainer iimuz

# set locale
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    apt-utils \
    locales && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# setup tools
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake \
    make && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# clang
RUN echo deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-5.0 main >> /etc/apt/sources.list && \
  echo deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-5.0 main >> /etc/apt/sources.list.d/deb-src.list  && \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    clang-5.0 \
    libclang-common-5.0-dev \
    libclang-5.0-dev \
    libclang1-5.0 \
    libclang1-5.0-dbg \
    libllvm5.0 \
    libllvm5.0-dbg \
    lldb-5.0 \
    llvm-5.0 \
    llvm-5.0-dev \
    llvm-5.0-runtime \
    clang-format-5.0 \
    liblldb-5.0-dev \
    lld-5.0 \
    libfuzzer-5.0-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ENV CC=clang-5.0 \
  CXX=clang++-5.0

# opencv
RUN apt-get update && apt-get install -y --no-install-recommends \
    checkinstall \
    pkg-config \
    libtiff5-dev \
    libjpeg-dev \
    libtbb-dev \
    unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  cd /opt && \
  git clone --depth 1 -b 3.3.1 https://github.com/opencv/opencv.git && \
  mkdir -p opencv/build && \
  cd ./opencv/build && \
  cmake \
    -G "Unix Makefiles" \
    --build . \
    -D BUILD_CUDA_STUBS=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_JASPER=OFF \
    -D BUILD_JPEG=OFF \
    -D BUILD_OPENEXR=OFF \
    -D BUILD_PACKAGE=ON \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_PNG=OFF \
    -D BUILD_SHARED_LIBS=ON \
    -D BUILD_TBB=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_TIFF=OFF \
    -D BUILD_WITH_DEBUG_INFO=ON \
    -D BUILD_ZLIB=OFF \
    -D BUILD_WEBP=OFF \
    -D BUILD_opencv_apps=OFF \
    -D BUILD_opencv_calib3d=OFF \
    -D BUILD_opencv_core=ON \
    -D BUILD_opencv_cudaarithm=OFF \
    -D BUILD_opencv_cudabgsegm=OFF \
    -D BUILD_opencv_cudacodec=OFF \
    -D BUILD_opencv_cudafeatures2d=OFF \
    -D BUILD_opencv_cudafilters=OFF \
    -D BUILD_opencv_cudaimgproc=OFF \
    -D BUILD_opencv_cudalegacy=OFF \
    -D BUILD_opencv_cudaobjdetect=OFF \
    -D BUILD_opencv_cudaoptflow=OFF \
    -D BUILD_opencv_cudastereo=OFF \
    -D BUILD_opencv_cudawarping=OFF \
    -D BUILD_opencv_cudev=OFF \
    -D BUILD_opencv_features2d=OFF \
    -D BUILD_opencv_flann=OFF \
    -D BUILD_opencv_highgui=ON \
    -D BUILD_opencv_imgcodecs=ON \
    -D BUILD_opencv_imgproc=ON \
    -D BUILD_opencv_java=OFF \
    -D BUILD_opencv_ml=OFF \
    -D BUILD_opencv_objdetect=OFF \
    -D BUILD_opencv_photo=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=OFF \
    -D BUILD_opencv_shape=OFF \
    -D BUILD_opencv_stitching=OFF \
    -D BUILD_opencv_superres=OFF \
    -D BUILD_opencv_ts=OFF \
    -D BUILD_opencv_video=OFF \
    -D BUILD_opencv_videoio=OFF \
    -D BUILD_opencv_videostab=OFF \
    -D BUILD_opencv_viz=OFF \
    -D BUILD_opencv_world=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D WITH_1394=OFF \
    -D WITH_CUBLAS=OFF \
    -D WITH_CUDA=OFF \
    -D WITH_CUFFT=OFF \
    -D WITH_EIGEN=ON \
    -D WITH_FFMPEG=OFF \
    -D WITH_GDAL=OFF \
    -D WITH_GPHOTO2=OFF \
    -D WITH_GIGEAPI=OFF \
    -D WITH_GSTREAMER=OFF \
    -D WITH_GTK=OFF \
    -D WITH_INTELPERC=OFF \
    -D WITH_IPP=ON \
    -D WITH_IPP_A=OFF \
    -D WITH_JASPER=OFF \
    -D WITH_JPEG=ON \
    -D WITH_LIBV4L=OFF \
    -D WITH_OPENCL=ON \
    -D WITH_OPENCLAMDBLAS=OFF \
    -D WITH_OPENCLAMDFFT=OFF \
    -D WITH_OPENCL_SVM=OFF \
    -D WITH_OPENEXR=OFF \
    -D WITH_OPENGL=OFF \
    -D WITH_OPENMP=OFF \
    -D WITH_OPENNI=OFF \
    -D WITH_PNG=ON \
    -D WITH_PTHREADS_PF=OFF \
    -D WITH_PVAPI=OFF \
    -D WITH_QT=OFF \
    -D WITH_TBB=ON \
    -D WITH_TIFF=ON \
    -D WITH_UNICAP=OFF \
    -D WITH_V4L=OFF \
    -D WITH_VTK=OFF \
    -D WITH_WEBP=ON \
    -D WITH_XIMEA=OFF \
    -D WITH_XINE=OFF \
    .. && \
  make -j$(grep processor /proc/cpuinfo | wc -l) && \
  make install && \
  cd .. && \
  rm -rf opencv && \
  ldconfig

# vim
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    ctags \
    lua5.2 \
    lua5.2-dev \
    global && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  cd /opt/ && \
  git clone --depth=1 -b v8.0.1365 https://github.com/vim/vim vim && \
  cd ./vim && \
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp \
    --enable-fail-if-missing \
    --prefix=/usr/local && \
  make && \
  make install && \
  cd .. && \
  rm -rf vim && \
  vim --version

# add dev user
ENV HOME /home/dev
COPY ./home $HOME
RUN adduser dev --disabled-password --gecos "" && \
  echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  chown -R dev:dev $HOME
USER dev

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein && \
  curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh && \
  sh $HOME/installer.sh $HOME/.cache/dein && \
  rm $HOME/installer.sh && \
  vim +":silent! call dein#install()" +qall

WORKDIR ${HOME}
