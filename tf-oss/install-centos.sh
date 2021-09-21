#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://docs.docker.com/install/linux/docker-ce/centos/

# remove old versions
yum remove ${TF_PACKAGE}

# list out the previously available versions
yum list available ${TF_PACKAGE} --showduplicates

# install repo
yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

# list out new newly available versions
yum list 'docker-ce' --showduplicates

# install docker
yum install -y ${TF_PACKAGE}-${DOCKER_VERSION} ${DOCKER_CLI_PACKAGE}-${DOCKER_VERSION} containerd.io
