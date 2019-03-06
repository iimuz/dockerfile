# docker-hugo

Docker image for static sites generated with Hugo

* [Hugo website](https://gohugo.io/)
* [GitHub: gohugoio/hugo](https://github.com/gohugoio/hugo)

## Usage

```sh
$ docker run --rm -it -v $(pwd):/src:rw -u $(id -u):$(id -g) iimuz/hugo:latest hugo
```

