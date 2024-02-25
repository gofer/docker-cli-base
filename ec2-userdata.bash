#!/bin/bash

set -xe

yum update && yum upgrade

yum install -y git docker python3-pip tmux

systemctl enable docker && systemctl start docker

usermod -aG docker ec2-user

su ec2-user << END_OF_SCRIPT

cd /home/ec2-user

git clone https://github.com/gofer/docker-cli-base

cd /home/ec2-user/docker-cli-base

if [ -f requirements.txt ]; then
  pip3 install -t vendor -r requirements.txt
fi

END_OF_SCRIPT
