#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# set default values, if not defined
if [[ -z "${HELM_PACKAGE-}" ]]; then
  HELM_PACKAGE="helm"
fi

# default to installing the latest available version
if [[ -z "${HELM_VERSION-}" ]]; then
  HELM_VERSION=$(curl -sSL https://github.com/helm/helm/releases \
    | grep -F '/helm/helm/tree/' | head -n1 | cut -d 'v' -f2 \
    | cut -d '"' -f1 | xargs
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
  . ./install-ubuntu-repo.sh
fi

# test
helm --version
