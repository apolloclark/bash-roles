#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# set default values, if not defined
if [[ -z "${VAULT_PACKAGE-}" ]]; then
  VAULT_PACKAGE="vault"
fi
if [[ -z "${VAULT_VERSION-}" ]]; then
  VAULT_VERSION=$(curl -sSLk https://releases.hashicorp.com/index.json \
    | jq ".vault.versions | keys | .[]" | tr -d '"' \
    | grep -v 'alpha\|beta\|rc\|oci\|ent' | sort --version-sort | tail -n1
  );
fi



# install CentOS version
if [ "$DISTRO_OS" == "centos" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -lt "7" ]; then
    echo "[ERROR] CentOS 7.x or newer must be used."
    exit 1;
  fi
  . ./install-centos.sh
fi

# install RHEL version (uses the CentOS repo)
# Docker requires a linux kernel 3.10+, RHEL 6.x uses 2.6, and RHEL 8.x
# uses Podman.
if [ "$DISTRO_OS" == "rhel" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -lt "7" ]; then
    echo "[ERROR] RHEL 7.x or newer must be used."
    exit 1;
  fi
  . ./install-centos.sh
fi

# install Oralce Linux version
if [ "$DISTRO_OS" == "ol" ]; then
  echo "[ERROR] Oracle Linux is not supported"
  exit 1;
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
systemctl enable vault.service
systemctl start vault
vault --version
