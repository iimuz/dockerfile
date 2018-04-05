FROM python:3.6.3-stretch
LABEL maintainer "iimuz"

# set locale
RUN apt update && apt install -y --no-install-recommends \
    apt-utils \
    task-japanese \
    locales && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen && \
  locale-gen && \
  update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# install texlive
RUN apt update && apt install -y --no-install-recommends \
    latexmk \
    texlive \
    texlive-formats-extra \
    texlive-lang-japanese && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

# install sphinx
RUN pip3 install sphinx==1.7.2

# install plantuml
RUN apt update && apt install -y --no-install-recommends \
    graphviz \
    openjdk-8-jre && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate && \
  mkdir /usr/local/plantuml && \
  mv plantuml.jar /usr/local/plantuml/ && \
  pip3 install \
    sphinxcontrib-actdiag==0.8.5 \
    sphinxcontrib-blockdiag==1.5.5 \
    sphinxcontrib-nwdiag==0.9.5 \
    sphinxcontrib-plantuml==0.11 \
    sphinxcontrib-seqdiag==0.8.5

# add dev user
ENV HOME /home/dev
RUN adduser dev --disabled-password --gecos "" \
  && echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R dev:dev $HOME
USER dev

WORKDIR $HOME

