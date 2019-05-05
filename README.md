# Meta Trader 4

## Usage

### X11 Forwarding type

```sh
$ docker run --rm -it -e DISPLAY=$DISPLAY -v ~/.Xauthority:/root/.Xauthority:ro iimuz/metatrader:latest
```

### Ubuntu Desktop

```sh
$ docker run --rm -p 8080:8080 iimuz/metatrader:desktop
```

* xvfbによる仮想ディスプレイ
* xfceによる軽量デスクトップ環境
* x11vncによるリモートデスクトップ(ポートはコンテナ外に非公開)
* noVNCによるブラウザによるリモートデスクトップ

## ビルド手順

MT4 のバイナリを取得するために、下記手順で docker image を作成します。

1. wine までをインストールした docker image を作成する
1. 上記 image を利用して MT4 をインストールし、バイナリを抽出する
1. バイナリを最初の wine までをインストールした docker image に copy する部分を追加する

MT4 のみのバイナリだけだと、その他のデータをダウンロードすることを促されるため、
MT4 以外のバイナリも含めた docker image としています。

最初の docker image 作成段階では、 `COPY .wine` の部分を削除してビルドを行います。
その後、 MT4 のインストーラを持ってきて、作成した image でビルドします。

```sh
$ docker run --rm -it -e DISPLAY=$DISPLAY -v $(pwd)/metatrader4.exe:/tmp/metatrader4.exe -v $(pwd)/.wine:/root/.wine:rw -v ~/.Xauthority:/root/.Xauthority:ro meta4 bash
# in docker container
$ cd /tmp
$ wine metatrader4.exe
```

上記のように実行することで、 MT4 のインストーラ画面が転送され、 GUI を利用してインストール作業が行えます。
インストールすると `$(pwd)/.wine` にバイナリが一式作成できます。

### Ubuntu Desktop 版に関して

元は、 [GitHub uphy/ubuntu-desktop-jp] を利用しています。

[uphy]: https://github.com/uphy/ubuntu-desktop-jp

