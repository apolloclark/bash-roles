#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# set default values, if not defined
if [[ -z "${ANSIBLE_PACKAGE-}" ]]; then
  ANSIBLE_PACKAGE="ansible"
fi

if [[ -z "${ANSIBLE_VERSION-}" ]]; then
  ANSIBLE_VERSION=$(curl -sSL https://launchpad.net/~ansible/+archive/ubuntu/ansible/+packages \
    | grep -F 'ppa~' | head -n1 | cut -d '-' -f2 | xargs
  );
fi



# install CentOS version
if [ "$DISTRO_OS" == "centos" ]; then
  . ./install-centos.sh
fi

# install RHEL version (uses the CentOS repo)
if [ "$DISTRO_OS" == "rhel" ]; then
  . ./install-centos.sh
fi

# install Oralce Linux version
if [ "$DISTRO_OS" == "ol" ]; then
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
ansible --version
