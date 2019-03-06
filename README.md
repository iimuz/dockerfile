# python development settings using docker

python 環境を docker で用意し実行できるようにしている実験環境です。

## pipenv version

実行方法

```sh
$ docker run --rm -it -v $(pwd):/src:rw -u $(id -u):$(ig -g) iimuz/python-dev:pipenv pipenv run python
```

* user 指定により実行時のユーザ id を設定します。
* pipenv が利用するキャッシュディレクトリは /.cache になります。
* numpy などをインストールする際に gcc などが必要となるため、
  予め c 関連のビルドはできるだけのパッケージを含めています。

## science version

実行方法

```sh
$ docker run --rm -it -v $(pwd):/src:rw -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) iimuz/python-dev:science python
```

下記パッケージがあらかじめ含まれています。

* matplotlib
* numpy
* pandas
* scipy
* scikit-learn
* scikit-image

