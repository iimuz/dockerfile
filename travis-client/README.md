# docker travis client

## usage

```bash
$ docker run --rm -it -v /path/to/repository:/src:rw -u $(id -u):$(id -g) imuz/travis-client:latest bash
```

