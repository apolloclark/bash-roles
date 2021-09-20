#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# print info
echo "[INFO] running: bash-roles / install.sh"

# install packages
for PACKAGE_NAME in ${PACKAGES[@]}; do
  cd $PROJECT_DIR/$PACKAGE_NAME
  . ./install.sh
done

# clean
cd $PROJECT_DIR
. ./base/clean.sh
