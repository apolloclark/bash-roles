#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip

# check the python version
python3 --version

# alias python=python3
# apt install python-is-python3

# install pip
apt install -y python3-pip

# check the pip version
pip --version

# remove any existing installation
pip uninstall -yqqq ${ANSIBLE_PACKAGE}

# install
pip install ${ANSIBLE_PACKAGE}==${ANSIBLE_VERSION}
