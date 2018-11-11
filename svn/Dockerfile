FROM iimuz/git:dev
LABEL maintainer iimuz

# tools
RUN set -x && \
  apk update && \
  apk add --no-cache \
    git-svn \
    perl-git \
    subversion && \
  : "clean" && \
  rm -rf /var/cache/apk/*

