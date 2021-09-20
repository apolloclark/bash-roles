#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# retrieve a link to the latest version of Terraform
JQ_VERSION_LATEST=$(curl -sSL https://github.com/stedolan/jq/releases \
  | grep -F '/releases/tag' | grep -v 'rc' | head -n1 | cut -d'"' -f2 | cut -d'/' -f6 | cut -d'-' -f2);

# get the currently installed version
JQ_VERSION_CURRENT="";
if [ -x "$(command -v jq)" ]; then
  JQ_VERSION_CURRENT=$(jq --version | cut -d'-' -f2);
fi

# check if the latest version matches the currently installed version
if [ "$JQ_VERSION_LATEST" = "$JQ_VERSION_CURRENT" ]; then
  echo "Already running the latest version == $JQ_VERSION_CURRENT"
  return 0;
fi

# generate the download URL
JQ_URL=$(echo 'https://github.com/stedolan/jq/releases/download/jq-'"${JQ_VERSION_LATEST}"'/jq-linux64')
echo $JQ_URL;

# get the file, install it
cd /tmp
wget -q "$JQ_URL"
mv ./jq-linux64 /usr/bin/jq
chmod +x /usr/bin/jq
jq --version | grep -F "jq-$JQ_VERSION_LATEST"
rm -rf /tmp/jq*
