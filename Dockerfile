FROM ubuntu:18.04
LABEL maitaniner "iimuz"

RUN set -x && \
  : "install wine" && \
  fetchDeps=' \
    ca-certificates \
    gnupg \
    software-properties-common \
    wget \
  ' && \
  dpkg --add-architecture i386 && \
  apt update && \
  apt install -y --no-install-recommends $fetchDeps && \
  wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
  apt-key add winehq.key && \
  apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/ && \
  apt install --install-recommends winehq-stable -y && \
  apt remove -y $fetchDeps && \
  apt autoremove -y && \
  apt clean -y && \
  rm -rf /var/lib/apt/lists/* winehq.key
ENV WINEARCH win32

COPY .wine /root/.wine

CMD ["wine", "/root/.wine/drive_c/Program Files/Big Boss MetaTrader 4/terminal.exe", "/portable"]

