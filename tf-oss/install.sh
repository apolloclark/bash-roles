#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# set default values, if not defined
if [[ -z "${TF_PACKAGE-}" ]]; then
  TF_PACKAGE="terraform"
fi
if [[ -z "${TF_VERSION-}" ]]; then
  # DOCKER_VERSION="19.03.8"
  TF_VERSION=$(curl -sSL https://releases.hashicorp.com/terraform/ \
   | grep -F '"/terraform/' | grep -v 'alpha\|beta\|rc\|oci\|ent' \
   | head -n1 | cut -d '"' -f2 | cut -d '/' -f3
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

# test terraform
terraform --version
