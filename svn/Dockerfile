FROM iimuz/git:v2.0.0
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

