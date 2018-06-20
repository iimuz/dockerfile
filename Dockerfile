FROM iimuz/neovim:v0.3.0-2
LABEL maintainer iimuz

RUN set -x && \
  apt update && \
  apt install -y --no-install-recommends ctags python3-pip && \
  pip3 install --no-cache \
    flake8==3.5.0 \
    setuptools && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  gosu ${USER_NAME} nvim +":silent! call dein#install()" +qall
