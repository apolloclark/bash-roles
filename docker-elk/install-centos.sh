#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://docs.docker.com/install/linux/docker-ce/centos/

# remove old versions
yum remove docker-compose

# install base packages
yum install -y docker-compose
