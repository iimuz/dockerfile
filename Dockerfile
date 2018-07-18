FROM iimuz/neovim:v0.3.0-4
LABEL maintainer iimuz

RUN set -x && \
  apt update && \
  apt install -y --no-install-recommends ctags && \
  pip3 install --no-cache \
    flake8==3.5.0 && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  apt autoremove -y

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall
