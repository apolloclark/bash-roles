#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# set default values, if not defined
if [[ -z "${DOCKER_PACKAGE-}" ]]; then
  DOCKER_PACKAGE="docker-ce"
fi
if [[ -z "${DOCKER_CLI_PACKAGE-}" ]]; then
  DOCKER_CLI_PACKAGE="docker-ce-cli"
fi
if [[ -z "${DOCKER_VERSION-}" ]]; then
  # DOCKER_VERSION="19.03.8"
  DOCKER_VERSION=$(curl -sSL https://github.com/docker/docker-ce/releases \
    | grep -F '/docker/docker-ce/releases/tag' | head -n 2 | cut -d'>' -f2 \
    | cut -d'<' -f1 | cut -b2-
  );
  echo "DOCKER_VERSION = ${DOCKER_VERSION}"
fi



# install CentOS version
# Docker requires a linux kernel 3.10+, CentOS 6.x uses 2.6, and CentOS 8.x
# uses Podman.
if [ "$DISTRO_OS" == "centos" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -ne "7" ]; then
    echo "[ERROR] CentOS 6.x and 8.x do not support Docker."
    exit 1;
  fi
  . ./install-centos.sh
fi

# install RHEL version (uses the CentOS repo)
# Docker requires a linux kernel 3.10+, RHEL 6.x uses 2.6, and RHEL 8.x
# uses Podman.
if [ "$DISTRO_OS" == "rhel" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -ne "7" ]; then
    echo "[ERROR] RHEL 6.x and 8.x do not support Docker."
    exit 1;
  fi
  . ./install-centos.sh
fi

# install Oralce Linux version
if [ "$DISTRO_OS" == "ol" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -ne "7" ]; then
    echo "[ERROR] Oracle Linux 6.x and 8.x do not support Docker."
    exit 1;
  fi
  . ./install-ol.sh
fi

# install Ubuntu version
if [ "$DISTRO_OS" == "ubuntu" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -lt "16" ]; then
    echo "[ERROR] Ubuntu 14.04 went End of Life (EOL) on April 30, 2019."
    exit 1;
  fi
  . ./install-ubuntu.sh
fi

# start docker, run test container
systemctl enable docker.service
systemctl start docker
docker run hello-world
