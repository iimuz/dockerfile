FROM ruby:2.6.1-stretch
LABEL maintainer iimuz

RUN set -x && \
  : "install travis" && \
  gem install travis -v 1.8.9 -N

CMD ["travis"]

