# Dockerでいい感じのCLI環境を整えるやつ


## EC2インスタンス内でビルド

インスタンス起動時に`ec2-userdata.bash`をユーザーデータとして実行しておく

ログイン後に以下のようにコマンドを実行しDockerHubにpushする
```sh
$ tmux
$ git clone https://github.com/gofer/docker-cli-base
$ git checkout <<branch_name/tag_name>>
$ docker build \
    -f <<base>>.dockerfile \
    --tag docker-cli-base:<<base>>-yyyymmddxxx \
    --build-arg cica_ver=5.0.3 \
    --build-arg go_ver=1.22.0 \
    --cpu-period=100000 \
    --cpu-quota=20000 \
    .
$ docker login
$ docker tag docker-cli-base:<<base>>-yyyymmddxxx goferex/docker-cli-base:<<base>>-yyyymmddxxx
$ docker push goferex/docker-cli-base:<<base>>-yyyymmddxxx
$ docker tag docker-cli-base:<<base>>-yyyymmddxxx goferex/docker-cli-base:<<base>>
$ docker push goferex/docker-cli-base:<<base>>
```

現在サポートしている`<<base>>`
- `debian`
