FROM balenalib/raspberry-pi:latest
LABEL maintainer "iimuz"

RUN set -x \
  && apt-get update \
  && apt-get autoremove \
  && apt-get install -y fswebcam \
  && apt-get clean \
  && rm -rf /var/lib/apt/lits/*

WORKDIR /workspace
CMD ["fswebcam"]

