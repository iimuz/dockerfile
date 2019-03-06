# docker-gcloud

gcloud settings

## Usage

```sh
$ docker run --rm -it iimuz/gcloud:latest gcloud
```

ユーザID及びグループIDを変更したい場合は、下記のように実行します。

```sh
$ docker run --rm -it -u $(id -u):$(id -g) iimuz/gcloud:latest gcloud
```

## setup GCloud

```bash
$ gcloud init
$ gcloud auth application-default login
```

