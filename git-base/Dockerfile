FROM alpine:3.9
LABEL maintainer iimuz

COPY .gitconfig /.gitconfig
COPY .config /.config
RUN set -x && \
  : "install packages" && \
  apk update && \
  apk add --no-cache \
    ca-certificates \
    diffutils \
    git \
    less \
    netcat-openbsd \
    openssh && \
  : "neovim" && \
  apk add --no-cache neovim && \
  ln -s /usr/bin/nvim /usr/bin/vim && \
  mkdir -p /.local/share/nvim && \
  : "clean and settings" && \
  chmod 777 /.gitconfig /.config && \
  chmod 777 -R /.local && \
  rm -rf /var/cache/apk/*

CMD ["git"]

