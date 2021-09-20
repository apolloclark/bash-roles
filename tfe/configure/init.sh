#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# ensure that jq is installed
# https://github.com/stedolan/jq
if ! [ -x "$(command -v jq)" ]; then
  echo '[ERROR] jq is not installed, see https://github.com/stedolan/jq'
  exit 1;
fi

# set default values, if not defined
if [[ -z "${TFE_HOSTNAME-}" ]]; then
  export TFE_HOSTNAME="tfe-demo"
fi

# check that the TFE hostname is in /etc/hosts
if ! grep -q "${TFE_HOSTNAME}" /etc/hosts; then
  echo "[INFO] added ${TFE_HOSTNAME} to /etc/hosts"
  echo "127.0.0.1       ${TFE_HOSTNAME}" >> /etc/hosts
fi

# clear any existing cookies
echo "" > ./session_cookies.txt
