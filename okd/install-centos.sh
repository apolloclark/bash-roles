#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://github.com/openshift/okd
# https://github.com/openshift/installer/blob/master/docs/user/overview.md
# https://cloud.redhat.com/blog/guide-to-installing-an-okd-4-4-cluster-on-your-home-lab

# remove old versions
yum remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine

# install base packages
yum install -y yum-utils device-mapper-persistent-data lvm2

# list out the previously available versions
yum list available 'docker*' --showduplicates

# install repo
yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

# list out new newly available versions
yum list 'docker-ce' --showduplicates

# install docker
yum install -y ${DOCKER_PACKAGE}-${DOCKER_VERSION} ${DOCKER_CLI_PACKAGE}-${DOCKER_VERSION} containerd.io
# yum install docker-ce docker-ce-cli containerd.io

# (optional) install the docker systemd service file
yum install -y iptables-services
