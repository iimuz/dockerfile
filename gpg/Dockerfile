FROM iimuz/git:v2.0.0
LABEL maintainer iimuz

# tools
COPY .profile /.profile
RUN set -x && \
  apk update && \
  apk add --no-cache gnupg && \
  : "install git contrib" && \
  apk add --no-cache git-perl && \
  mkdir -p /usr/share/doc/git && \
  git clone --depth=1 -b v2.19.1 http://github.com/git/git /usr/share/doc/git && \
  rm -rf /usr/share/doc/git/.git && \
  CREDENTIAL_SCRIPT=/usr/share/doc/git/contrib/credential/netrc/git-credential-netrc && \
  chmod +x $CREDENTIAL_SCRIPT && \
  : "set git credential helper" && \
  echo -e "\n[credential]\nhelper = $CREDENTIAL_SCRIPT\n" >> /.gitconfig && \
  : "clean" && \
  rm -rf /var/cache/apk/*

