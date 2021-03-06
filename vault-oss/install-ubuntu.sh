#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://docs.docker.com/install/linux/docker-ce/ubuntu/

# remove old versions
apt-get remove -y ${VAULT_PACKAGE} || true

# add the HashiCorp Linux repo
# https://www.hashicorp.com/blog/announcing-the-hashicorp-linux-repository
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository \
  "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com \
  $(lsb_release -cs) main"
apt-get update

# list out new newly available versions
apt list -a ${VAULT_PACKAGE}

# install
apt-get install -y ${VAULT_PACKAGE}=${VAULT_VERSION}
