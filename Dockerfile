FROM buildpack-deps:stretch-scm
LABEL maintainer "iimuz"

# set locale
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# cpp dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    clang-format-3.8 \
    make \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# opencv
RUN apt-get -qq remove ffmpeg x264 libx264-dev \
  && apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    libtiff5-dev \
    libjpeg-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine2-dev \
    libgstreamer0.10-dev \
    libgstreamer-plugins-base0.10-dev \
    libv4l-dev \
    python-dev \
    python-numpy \
    libtbb-dev \
    libqt5x11extras5 \
    libqt5opengl5 \
    libqt5opengl5-dev \
    libgtk2.0-dev \
    libfaac-dev \
    libmp3lame-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    x264 \
    v4l-utils \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /opt \
  && git clone --depth 1 -b 3.3.1 https://github.com/opencv/opencv.git \
  && mkdir -p opencv/build \
  && cd ./opencv/build \
  && cmake \
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
    -D BUILD_opencv_apps=ON \
    -D BUILD_opencv_calib3d=ON \
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
    -D BUILD_opencv_features2d=ON \
    -D BUILD_opencv_flann=ON \
    -D BUILD_opencv_highgui=ON \
    -D BUILD_opencv_imgcodecs=ON \
    -D BUILD_opencv_imgproc=ON \
    -D BUILD_opencv_java=OFF \
    -D BUILD_opencv_ml=ON \
    -D BUILD_opencv_objdetect=ON \
    -D BUILD_opencv_photo=ON \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D BUILD_opencv_shape=ON \
    -D BUILD_opencv_stitching=ON \
    -D BUILD_opencv_superres=ON \
    -D BUILD_opencv_ts=ON \
    -D BUILD_opencv_video=ON \
    -D BUILD_opencv_videoio=ON \
    -D BUILD_opencv_videostab=ON \
    -D BUILD_opencv_viz=OFF \
    -D BUILD_opencv_world=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D WITH_1394=ON \
    -D WITH_CUBLAS=OFF \
    -D WITH_CUDA=OFF \
    -D WITH_CUFFT=OFF \
    -D WITH_EIGEN=ON \
    -D WITH_FFMPEG=ON \
    -D WITH_GDAL=OFF \
    -D WITH_GPHOTO2=OFF \
    -D WITH_GIGEAPI=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_GTK=ON \
    -D WITH_INTELPERC=OFF \
    -D WITH_IPP=ON \
    -D WITH_IPP_A=OFF \
    -D WITH_JASPER=ON \
    -D WITH_JPEG=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_OPENCL=ON \
    -D WITH_OPENCLAMDBLAS=OFF \
    -D WITH_OPENCLAMDFFT=OFF \
    -D WITH_OPENCL_SVM=OFF \
    -D WITH_OPENEXR=ON \
    -D WITH_OPENGL=ON \
    -D WITH_OPENMP=OFF \
    -D WITH_OPENNI=OFF \
    -D WITH_PNG=ON \
    -D WITH_PTHREADS_PF=OFF \
    -D WITH_PVAPI=ON \
    -D WITH_QT=OFF \
    -D WITH_TBB=ON \
    -D WITH_TIFF=ON \
    -D WITH_UNICAP=OFF \
    -D WITH_V4L=OFF \
    -D WITH_VTK=OFF \
    -D WITH_WEBP=ON \
    -D WITH_XIMEA=OFF \
    -D WITH_XINE=OFF \
    .. \
  && make -j4 \
  && make install \
  && ldconfig \
  && opencv_version

# vim
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libc-dev \
    lua5.2 \
    lua5.2-dev \
    luajit \
    ctags \
    gcc \
    global \
    ncurses-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /opt/ \
  && git clone --depth=1 -b v8.0.1365 https://github.com/vim/vim vim \
  && cd ./vim \
  && ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp=dynamic \
    --enable-gpm \
    --enable-cscope \
    --enable-fontset \
    --enable-fail-if-missing \
    --prefix=/usr/local \
  && make && make install \
  && vim --version

# add dev user
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev /home/dev
USER dev
ENV HOME /home/dev

# install dein.vim
RUN mkdir -p ${HOME}/.cache/dein \
  && curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh \
  && sh $HOME/installer.sh $HOME/.cache/dein \
  && rm $HOME/installer.sh

# install plugins
RUN mkdir -p $HOME/.vim/rc
COPY .vimrc $HOME/.vimrc
COPY .globalrc $HOME/.globalrc
COPY dein.toml $HOME/.vim/rc/dein.toml
COPY dein_lazy.toml $HOME/.vim/rc/dein_lazy.toml
RUN vim +":silent! call dein#install()" +qall

# bash
COPY .bashrc $HOME/.bashrc
COPY .bash_profile $HOME/.bash_profile

WORKDIR ${HOME}

