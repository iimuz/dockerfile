FROM google/cloud-sdk:262.0.0-alpine
LABEL maintainer "iimuz"

RUN set -x \
  && : "install beta components" \
  && gcloud components install beta \
  && gcloud components update

RUN set -x \
  && : "install cloud functions emulator" \
  && apk update \
  && apk add --no-cache \
    nodejs \
    npm \
  && npm install -g @google-cloud/functions-framework \
  && : "clean" \
  && rm -rf /var/cache/apk/*

CMD ["gcloud"]

