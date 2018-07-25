FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build-peco

RUN set -x && \
  go get -d github.com/peco/peco && \
  cd /go/src/github.com/peco/peco && \
  git checkout refs/tags/v0.5.3 && \
  glide install && \
  go build cmd/peco/peco.go && \
  mv ./peco /go/bin/peco

FROM iimuz/golang-dev:v1.10.2-1.2.0 AS build-ghq

RUN set -x && \
  go get github.com/motemen/ghq

FROM alpine:3.8
LABEL maintainer iimuz

# locale and timezone
ENV LANG="ja_JP.UTF-8" \
  LANGUAGE="ja_JP:ja" \
  LC_ALL="ja_JP.UTF-8"
RUN set -x && \
  apk update && \
  apk add --no-cache tzdata && \
  rm -rf /var/cache/apk/*

# add user
ENV USER_NAME=git \
  HOME=/home/git \
  USER_ID=1000 \
  GROUP_ID=1000
RUN set -x && \
  apk update && \
  apk add --no-cache su-exec shadow && \
  rm -rf /var/cache/apk/* && \
  adduser ${USER_NAME} --uid ${USER_ID} --disabled-password --gecos ""

# tools
COPY --from=build-ghq /go/bin/ghq /usr/bin/
COPY --from=build-peco /go/bin/peco /usr/bin/
ENV ENV=${HOME}/.profile
RUN set -x && \
  apk update && \
  apk add --no-cache \
    ca-certificates \
    diffutils \
    less \
    netcat-openbsd \
    openssh \
    subversion && \
  : "ssh" && \
  mkdir ~/.ssh && \
  : "git" && \
  apk add --no-cache git && \
  git clone --depth=1 -b v0.1.0 https://github.com/iimuz/dotfiles.git ${HOME}/dotfiles && \
  mv ~/dotfiles/.gitconfig ${HOME}/ && \
  : "neovim" && \
  apk add --no-cache neovim && \
  ln -s /usr/bin/nvim /usr/bin/vim && \
  mkdir -p ~/.config/nvim && \
  mv ~/dotfiles/.config/nvim/init.vim ~/.config/nvim/ && \
  : "ghq" && \
  echo -e "\n[ghq]\n  root = /src\n" >> ~/.gitconfig.local && \
  : "peco" && \
  echo "alias ffghq='cd \$(ghq root)/\$(ghq list | peco)'" >> ~/.profile && \
  : "clean" && \
  chown -R ${USER_NAME}:${USER_NAME} ${HOME} && \
  rm -rf ${HOME}/dotfiles && \
  rm -rf /var/cache/apk/*

ENV SOURCE_DIR=/src
RUN set -x && mkdir ${SOURCE_DIR}

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
WORKDIR ${SOURCE_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ash"]
