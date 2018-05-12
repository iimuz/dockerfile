# docker-debian-dev

basic development environment using debian

## Usage

```sh
$ docker run --rm -it iimuz/debian-dev:latest
```

ユーザID及びグループIDを変更したい場合は、下記のように実行します。

```sh
$ docker run --rm -it -e USER_ID=1002 -e GROUP_ID=1003 iimuz/debian-dev:latest
```

dockerの実行ユーザをrootにしてもentrypointで実行ユーザを変更するようにしています。
そのため、rootユーザで実行したい場合は、entrypointを上書きするか、
下記のようにユーザIDとグループIDを0(root)に設定してください。

```sh
$ docker run --rm -it -e USER_ID=0 -e GROUP_ID=0 iimuz/debian-dev:latest
```

or

```sh
$ docker run --rm -it --entrypoint bash iimuz/debian-dev:latest
```
