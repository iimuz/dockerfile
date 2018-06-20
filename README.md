# docker-neovim

docker image for neovim

# flavor

* basic: default neovim using no plugins.
* slim: neovim with small plugins.
* md: neovim for markdown.
* py: neovim for python.
* latest: maybe equal to slim. no tags version.
* dev: development version. unstable.

# Usage

```sh
$ docker run --rm -it -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) iimuz/neovim:latest
```
