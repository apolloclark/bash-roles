#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# https://docs.docker.com/compose/install/

# remove old versions
apt-get remove -y docker-compose|| true

# install docker-compose
apt-get install -y docker-compose
