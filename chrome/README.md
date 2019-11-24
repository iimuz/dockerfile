# Dockerfile for google chrome

[chrome](https://www.google.co.jp/chrome/browser/desktop/index.html)

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
$ docker run --rm -e DISPLAY=$ip:0 iimuz/chrome
```

