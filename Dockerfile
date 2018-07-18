FROM iimuz/neovim:v0.3.0-4
LABEL maintainer iimuz

# plugins
COPY .vim /opt/.vim
RUN set -x && \
  su-exec ${USER_NAME} nvim +":silent! call dein#install()" +qall
