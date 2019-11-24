FROM debian:stretch
LABEL maintainer iimuz

# set locale
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    apt-utils \
    fonts-arphic-uming \
    locales && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    gnupg2 \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install -y --no-install-recommends google-chrome-stable

# add dev user
ENV HOME /home/dev
RUN adduser dev --disabled-password --gecos "" && \
  echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  chown -R dev:dev $HOME
USER dev

WORKDIR ${HOME}
ENTRYPOINT google-chrome --no-sandbox --disable-gpu

