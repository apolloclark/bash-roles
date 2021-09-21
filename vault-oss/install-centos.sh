#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://www.vaultproject.io/docs/install
# https://learn.hashicorp.com/tutorials/vault/getting-started-install


# remove old versions
yum remove ${VAULT_PACKAGE}

# install base packages
yum install -y yum-utils

# list out the previously available versions
yum list available "${VAULT_PACKAGE}*" --showduplicates

# install repo
yum-config-manager \
  --add-repo \
  https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# list out new newly available versions
yum list ${VAULT_PACKAGE} --showduplicates

# install docker
yum install -y ${VAULT_PACKAGE}-${VAULT_VERSION}
