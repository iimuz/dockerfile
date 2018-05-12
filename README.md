# docker-gcloud

gcloud settings

## Usage

```sh
$ docker run --rm -it iimuz/gcloud:latest
```

ユーザID及びグループIDを変更したい場合は、下記のように実行します。

```sh
$ docker run --rm -it -e USER_ID=1002 -e GROUP_ID=1003 iimuz/gcloud:latest
```

dockerの実行ユーザをrootにしてもentrypointで実行ユーザを変更するようにしています。
そのため、rootユーザで実行したい場合は、entrypointを上書きするか、
下記のようにユーザIDとグループIDを0(root)に設定してください。

```sh
$ docker run --rm -it -e USER_ID=0 -e GROUP_ID=0 iimuz/gcloud:latest
```

or

```sh
$ docker run --rm -it --entrypoint bash iimuz/gcloud:latest
```

## setup GCloud

```bash
$ gcloud init
$ gcloud auth application-default login
```

## Usage terraform

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## SSH

```bash
$ gcloud compute ssh <instance name>
```
