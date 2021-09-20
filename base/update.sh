#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  

if [ -x "$(command -v apt-get)" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -yq
elif [ -x "$(command -v dnf)" ]; then
    dnf makecache
elif [ -x "$(command -v yum)" ]; then
    yum makecache fast
    yum update -y
fi
