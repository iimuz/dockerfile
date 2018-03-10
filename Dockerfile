FROM ruby:2.5.0-stretch
LABEL maintainer iimuz

RUN gem install travis -v 1.8.8 --no-rdoc --no-ri

# add dev user
ENV HOME /home/dev
RUN adduser dev --disabled-password --gecos "" && \
  echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  chown -R dev:dev $HOME
USER dev

WORKDIR $HOME
