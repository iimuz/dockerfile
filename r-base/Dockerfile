FROM r-base:3.5.2
LABEL maintainer "iimuz"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && : "Install renv" \
  && R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))" \
  && R -e "remotes::install_github('rstudio/renv')"

RUN set -x \
  && : "create home directory for all user" \
  && mkdir -p /home/dev \
  && chmod 777 /home/dev

ENV DEBIAN_FRONTEND=dialog \
  SHELL=/bin/bash \
  HOME=/home/dev
CMD ["R"]
