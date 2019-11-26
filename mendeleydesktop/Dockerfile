FROM ubuntu:18.04
LABEL maintainer iimuz

# set locale to japanese and install fonts
RUN apt update && \
  apt install -y --no-install-recommends \
    apt-utils \
    fonts-takao \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8

# install mendeley desktop
RUN apt update && \
  apt install -y --no-install-recommends \
    ca-certificates \
    desktop-file-utils \
    gconf2 \
    libasound2 \
    libxcomposite-dev \
    libegl1-mesa \
    libfontconfig \
    libfreetype6-dev \
    libglu1-mesa \
    libnss3 \
    libxcursor-dev \
    libxi-dev \
    libxrandr2 \
    libxtst-dev \
    python \
    wget && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest && \
  dpkg -i mendeleydesktop-latest && \
  rm mendeleydesktop-latest && \
  mkdir -p /usr/share/X11/xkb
ENV QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

CMD ["mendeleydesktop"]
