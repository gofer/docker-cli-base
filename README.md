# Dockerでいい感じのCLI環境を整えるやつ


## EC2インスタンス内でビルド

インスタンス起動時に`ec2-userdata.bash`をユーザーデータとして実行しておく

ログイン後に以下のようにコマンドを実行しDockerHubにpushする
```sh
$ git clone https://github.com/gofer/docker-cli-base
$ git checkout <<branch_name>>
$ vi docker-compose.yml
# ここでバージョンを変更
#   20240218001 -> yyyymmddxxx
$ docker compose build <<base>>
$ docker tag docker-cli-base:<<base>>-yyyymmddxxx goferex/docker-cli-base:<<base>>-yyyymmddxxx
$ docker push goferex/docker-cli-base:<<base>>-yyyymmddxxx
$ docker tag docker-cli-base:<<base>>-yyyymmddxxx goferex/docker-cli-base:<<base>>
$ docker push goferex/docker-cli-base:<<base>>
```

現在サポートしている`<<base>>`
- `debian`
