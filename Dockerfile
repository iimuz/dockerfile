FROM google/cloud-sdk:237.0.0-alpine
LABEL maintainer "iimuz"

RUN set -x && \
  : "install cloud functions emulator" && \
  apk update && \
  apk add --no-cache \
    nodejs \
    npm && \
  npm install -g @google-cloud/functions-emulator && \
  : "clean" && \
  rm -rf /var/cache/apk/*

CMD ["gcloud"]

