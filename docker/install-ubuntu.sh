#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://docs.docker.com/install/linux/docker-ce/ubuntu/

# remove old versions
apt-get remove -y \
  docker docker-engine docker.io containerd runc || true

# install base packages
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# install repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update

# list out new newly available versions
apt-cache policy 'docker-ce'

# set the package name, based on the Ubuntu version
DOCKER_PACKAGE_VERSION="(NULL)";
if [ "$DISTRO_VERSION_MAJOR" -eq "20" ]; then
  DOCKER_PACKAGE_VERSION="5:${DOCKER_VERSION}~3-0~ubuntu-focal";
fi
if [ "$DISTRO_VERSION_MAJOR" -eq "18" ]; then
  DOCKER_PACKAGE_VERSION="5:${DOCKER_VERSION}~3-0~ubuntu-bionic";
fi
if [ "$DISTRO_VERSION_MAJOR" -eq "16" ]; then
  DOCKER_PACKAGE_VERSION="5:${DOCKER_VERSION}~3-0~ubuntu-xenial";
fi

# install docker
apt-get install -y ${DOCKER_PACKAGE}=${DOCKER_PACKAGE_VERSION} \
  ${DOCKER_CLI_PACKAGE}=${DOCKER_PACKAGE_VERSION} \
  containerd.io
# yum install docker-ce docker-ce-cli containerd.io
