#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/


# ensure we're on a Linux system
if [[ "$OSTYPE" != "linux-gnu" ]]; then
  echo "[ERROR] Unsupported OS! Use Linux."
  exit 1;
fi

if [ -f /etc/os-release ]; then
    # RHEL 7.x, CentOS 7.x, Ubuntu 18.04
    . /etc/os-release
    DISTRO_OS="$ID"
    DISTRO_VERSION="$VERSION_ID"

    # retrieve full CentOS version, default is just the first digit
    if [ "$DISTRO_OS" == "centos" ]; then
        export DISTRO_VERSION=$(cat /etc/redhat-release | awk -F' ' '{print $4}')
    fi
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    DISTRO_OS=$(cat /etc/redhat-release | cut -f1 -d' ' | awk '{print tolower($0)}')
    DISTRO_VERSION=$(cat /etc/redhat-release | cut -f3 -d' ')

    # retrieve full CentOS version, default is just the first digit
    if [ "$DISTRO_OS" == "red" ]; then
        DISTRO_OS="rhel"
        DISTRO_VERSION=$(cat /etc/redhat-release | cut -f7 -d' ')
    fi
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    DISTRO_OS=$(lsb_release -si)
    DISTRO_VERSION=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    DISTRO_OS=$DISTRIB_ID
    DISTRO_VERSION=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    DISTRO_OS="Debian"
    DISTRO_VERSION=$(cat /etc/debian_version)
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    DISTRO_OS=$(uname -s)
    VER=$(uname -r)
    echo "[ERROR] Who hurt you?"
    exit 1;
fi

# grab the version major, first digit in front of a period
DISTRO_VERSION_MAJOR=$(echo $DISTRO_VERSION | awk -F. '{print $1}')



# export values, for usage in parent scripts
export DISTRO_OS
export DISTRO_VERSION
export DISTRO_VERSION_MAJOR
