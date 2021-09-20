#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# retrieve a link to the latest version
PACKER_VERSION_LATEST=$(curl -sSL https://releases.hashicorp.com/packer/ \
  | grep -F '"/packer/' | head -n1 | cut -d '"' -f2 | cut -d '/' -f3);

# get the currently installed version
PACKER_VERSION_CURRENT="";
if [ -x "$(command -v packer)" ]; then
  PACKER_VERSION_CURRENT=$(packer -v | cut -d' ' -f2 | cut -c 2-);
fi

# check if the latest version matches the currently installed version
if [ "$PACKER_VERSION_LATEST" = "$PACKER_VERSION_CURRENT" ]; then
  echo "Already running the latest version == $PACKER_VERSION_CURRENT"
  return 0;
fi

# generate the download URL
PACKER_URL=$(echo 'https://releases.hashicorp.com/packer/'"${PACKER_VERSION_LATEST}"'/packer_'"${PACKER_VERSION_LATEST}"'_linux_amd64.zip')
echo $PACKER_URL;

# get the file, install it
cd /tmp
wget -q "$PACKER_URL"
unzip ./packer_*.zip
mv ./packer /usr/bin/packer
chmod +x /usr/bin/packer
# packer --version 2>&1 | grep -F "${PACKER_VERSION_LATEST}"
rm -rf /tmp/packer*
