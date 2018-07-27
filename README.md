# docker-git

docker image for git

# Usage

```sh
$ docker run --rm -it -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) iimuz/git:latest
```

if you use root user:

```sh
$ docker run --rm -it -e USER_ID=0 -e GROUP_ID=0 iimuz/git:latest
```

# Flavor

* svn: add subversion packages for git-svn.
* latest: maybe equal to slim. no tags version.
* dev: development version. unstable.
