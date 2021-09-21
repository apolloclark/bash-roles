#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://helm.sh/docs/intro/install/#from-apt-debianubuntu

# remove old versions
apt-get remove -y \
  ${HELM_PACKAGE} || true

# install repo
curl https://baltocdn.com/helm/signing.asc | apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update

# list out new newly available versions
apt-cache policy ${HELM_PACKAGE}

# install
apt-get install -y ${HELM_PACKAGE}=${HELM_VERSION}
