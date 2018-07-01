FROM iimuz/neovim:v0.3.0-3
LABEL maintainer iimuz

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  gosu ${USER_NAME} nvim +":silent! call dein#install()" +qall
