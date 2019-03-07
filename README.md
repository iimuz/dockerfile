# docker-git

docker image for git

## Usage

```sh
$ docker run --rm -it -u $(id -u):$(id -g) iimuz/git:latest
```

## Flavor

* dev: development version. unstable.
* gpg: add gnupg packages.
* latest: maybe equal to slim. no tags version.
* svn: add subversion packages for git-svn.

