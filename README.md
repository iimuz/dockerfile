# docker-golang-dev

Golang development tools in docker container.

# flavor

* basic: default development environment.
* latest: maybe equal to basic. no tags version.
* dev: development version. unstable.

# tools 

* [dep](https://github.com/golang/dep)
  * > Go dependency management tool
* [ghq](https://github.com/motemen/ghq)
  * > Remote repository management made easy
* [make2help](https://github.com/Songmu/make2help)
  * > Utility for self-documented Makefile

## deprecated

* [glide](https://github.com/Masterminds/glide)
  * > Package Management for Golang
  * Deprecated tool, but many repositories use this tool.

## Usage

```sh
$ docker run --rm -it iimuz/golang-dev:latest
```

ユーザID及びグループIDを変更したい場合は、下記のように実行します。

```sh
$ docker run --rm -it -e USER_ID=1001 -e GROUP_ID=1001 iimuz/golang-dev:latest
```

dockerの実行ユーザをrootにしてもentrypointで実行ユーザを変更するようにしています。
そのため、rootユーザで実行したい場合は、entrypointを上書きするか、
下記のようにユーザIDとグループIDを0(root)に設定してください。

```sh
$ docker run --rm -it -e USER_ID=0 -e GROUP_ID=0 iimuz/golang-dev:latest
```

or

```sh
$ docker run --rm -it --entrypoint bash iimuz/golang-dev:latest
```
