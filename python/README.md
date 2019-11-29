# python development settings using docker

python 環境を docker で実行可能にしている実験用環境です。

## 実行方法

```sh
# use default python environment
$ docker run --rm -it -v $(pwd):/src:rw -u $(id -u):$(ig -g) iimuz/python-dev:latest python
# or use pipenv environment
$ docker run --rm -it -v $(pwd):/src:rw -u $(id -u):$(ig -g) iimuz/python-dev:latest pipenv run python
```

* user 指定により実行時のユーザ id を設定します。
* pipenv が利用するキャッシュディレクトリは /.cache になります。
* numpy などをインストールする際に gcc などが必要となるため、
  予め c 関連のビルドはできるだけのパッケージを含めています。

