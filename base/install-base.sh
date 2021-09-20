#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  

if [ -x "$(command -v apt-get)" ]; then
    apt-get install -yq aptitude software-properties-common \
      nano curl wget git gnupg2 apt-transport-https dnsutils python unzip
elif [ -x "$(command -v dnf)" ]; then
    dnf --assumeyes install which nano curl wget git gnupg2 initscripts \
        hostname lsof bind-utils nmap-ncat unzip
    dnf clean all
elif [ -x "$(command -v yum)" ]; then
    yum install -y which nano curl wget git gnupg2 initscripts hostname lsof \
        bind-utils nmap-ncat unzip
    yum clean all
fi
