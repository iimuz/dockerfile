# docker-golang-dev

Golang development tools in docker container.

* [dep](https://github.com/golang/dep)
  * > Go dependency management tool
* [ghq](https://github.com/motemen/ghq)
  * > Remote repository management made easy
* [nvim](https://github.com/neovim/neovim)
  * > Vim-fork focused on extensibility and usability.
* [swig](https://github.com/swig/swig)
  * > SWIG is a software development tool that connects programs written in C and C++ with a variety of high-level programming languages.
* tmux
* [vim](https://github.com/vim/vim)

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
$ docker run --rm -it -e USER_ID=1002 -e GROUP_ID=1003 iimuz/golang-dev:latest
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
