#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu

# remove old versions
apt-get remove -y \
  ${ANSIBLE_PACKAGE} || true

# install repo
add-apt-repository ppa:ansible/ansible
apt-get update

# list out new newly available versions
apt-cache policy ${ANSIBLE_PACKAGE}

# install
apt-get install -y ${ANSIBLE_PACKAGE}=${ANSIBLE_VERSION}
