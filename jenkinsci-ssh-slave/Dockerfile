FROM jenkinsci/ssh-slave:latest
LABEL maintainer "iimuz"

# install docker
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    apt-transport-https \
    curl \
    lsb-release \
    software-properties-common && \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
  apt-get update && \
  apt-get install -y --no-install-recommends docker-ce && \
  usermod -aG docker jenkins && \
  rm -rf /var/lib/apt/lists/*
