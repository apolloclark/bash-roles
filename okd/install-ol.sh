#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://oracle-base.com/articles/linux/docker-install-docker-on-oracle-linux-ol7
# https://docs.docker.com/ee/docker-ee/oracle/

# remove old versions
yum remove -y docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine \
  docker-engine-selinux

# list out the previously available versions
yum list available 'docker*' --showduplicates || true

# remove old repos
rm -f /etc/yum.repos.d/docker*.repo
rm -f /etc/yum.repos.d/oracle-linux-ol7.repo
rm -f /etc/yum.repos.d/uek-ol7.repo
rm -f /etc/yum.repos.d/virt-ol7.repo

# install repo
wget --quiet -O /etc/yum.repos.d/public-yum-ol7.repo \
  http://yum.oracle.com/public-yum-ol7.repo

# install base packages
yum install -y yum-utils device-mapper-persistent-data lvm2

# enable extras repo
yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_preview
yum-config-manager --enable ol7_developer

# list out possible versions
yum list 'docker-engine' --showduplicates || true

# install docker
yum install -y docker-engine-${DOCKER_VERSION} docker-cli-${DOCKER_VERSION} containerd.io
# yum install docker-engine docker-cli containerd.io
