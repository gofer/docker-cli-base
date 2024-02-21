#!/bin/bash

set -xe

export DOCKER_COMPOSE_VERSION=2.24.6

yum update && yum upgrade

yum install -y git docker python3-pip tmux

systemctl enable docker && systemctl start docker

usermod -aG docker ec2-user

mkdir -p /usr/local/lib/docker/cli-plugins
cd /usr/local/lib/docker/cli-plugins
curl -OL https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 docker-compose
chmod +x docker-compose