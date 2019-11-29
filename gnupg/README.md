# docker gnupg

gnupg command using docker.

## Usage

```sh
$ docker --rm -it -u $(id -u):$(id -g) iimuz/gnupg:latest gpg
```

### gpg-agent

gpg-agent をあらかじめ起動し、コンテナを起動した状態にします。
他のコマンドや gpg-agent へ問い合わせが必要な別のコンテナには、
`/run/usr/$(id -u)/` を共有し gpg-agent を利用します。

```sh
$ docker --rm -it --name gpg_agent \
  -v ~/.gnupg:/.gnupg \
  -v gnupg_src:/run/usr/$(id -u)/:ro \
  -u $(id -u):$(id -g) \
  iimuz/gnupg:latest ash -c "gpg-agent --daemon; ash"
```

### gpg command

gpg-agent コンテナが起動している状態でボリュームを共有しコマンドを実行します。
gpg コマンドを直接呼んでもよいのですが、
入力ができないため一度 ash に入り、それから gpg コマンドを利用します。
コマンド以外の入力が必要ない場合は直接コマンドを呼び出せるはずです。

```sh
$ docker --rm -it \
  --volumes-from gpg_agent \
  -u $(id -u):$(id -g) \
  iimuz/gnupg:latest ash
```

