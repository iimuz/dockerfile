FROM python:3.7.2-stretch
LABEL maintainer "iimuz"

# install pipenv
RUN set -x && \
  : "install pipenv" && \
  pip --no-cache-dir install pipenv && \
  : "set cache dir for pipenv" && \
  mkdir -p /.cache && \
  chmod 777 /.cache
ENV PIPENV_VENV_IN_PROJECT=1

CMD ["python"]

