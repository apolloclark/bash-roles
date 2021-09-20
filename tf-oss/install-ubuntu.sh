#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://docs.docker.com/install/linux/docker-ce/ubuntu/

# remove old versions
apt-get remove -y \
  terraform || true

# install base packages
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# install repo
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository \
  "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com \
  $(lsb_release -cs) main"
apt-get update

# list out new newly available versions
apt-cache policy 'terraform'

# install docker
apt-get install -y ${TF_PACKAGE}=${TF_VERSION}
