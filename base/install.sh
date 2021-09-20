#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# update OS
. ./update.sh > /dev/null

# install base packages
. ./install-base.sh
