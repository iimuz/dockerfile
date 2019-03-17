# docker-neovim

docker image for neovim

# flavor

* basic: default neovim using no plugins.
* slim: neovim with small plugins.
* golang: neovim for golang.
* md: neovim for markdown.
* py: neovim for python.
* cpp: neovim for c++.
* latest: maybe equal to slim. no tags version.
* dev: development version. unstable.

# Usage

```sh
$ docker run --rm -it -u $(id -u):$(id -g) iimuz/neovim:latest
```
