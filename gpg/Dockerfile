FROM iimuz/git:dev
LABEL maintainer iimuz

# tools
RUN set -x && \
  apk update && \
  apk add --no-cache gnupg && \
  : "setting for gnupg" && \
  echo -e "\nalias gpg='gpg --pinentry-mode=loopback'\n" >> $HOME/.profile && \
  : "install git contrib" && \
  apk add --no-cache git-perl && \
  mkdir -p /usr/share/doc/git && \
  git clone --depth=1 -b v2.19.1 http://github.com/git/git /usr/share/doc/git && \
  rm -rf /usr/share/doc/git/.git && \
  CREDENTIAL_SCRIPT=/usr/share/doc/git/contrib/credential/netrc/git-credential-netrc && \
  chmod +x $CREDENTIAL_SCRIPT && \
  : "set git credential helper" && \
  GIT_CONFIG_DIR=$HOME/.config/git && \
  mkdir -p $GIT_CONFIG_DIR && \
  echo -e "\n[credential]\nhelper = $CREDENTIAL_SCRIPT\n" >> $GIT_CONFIG_DIR/local.config && \
  : "clean" && \
  rm -rf /var/cache/apk/*

