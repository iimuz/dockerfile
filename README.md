# Dockerfile for mocmix

[mcomix](https://sourceforge.net/projects/mcomix/)

## Usage(Mac OS)

Install follwing packages using homebrew.

```bash
$ brew install xquartz socat
```

To use:

```bash
$ open -a xquartz
$ $ip = ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'
$ xhost + $ip
$ socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
$ docker run --rm -e DISPLAY=$ip -v /src/data/path:/read/data/path:ro iimuz/mcomix
```

