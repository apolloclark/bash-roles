#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# set default values, if not defined
if [[ -z "${REPLICATED_PACKAGE_VERSION-}" ]]; then
  # REPLICATED_PACKAGE_VERSION="2.43.0"
  REPLICATED_PACKAGE_VERSION=$(curl -sSL https://release-notes.replicated.com/ \
    | grep -F 'blog-post-title' | head -n1 | cut -d'>' -f2 | cut -d'<' -f1
  );
fi



# install the Replicated CLI
# https://help.replicated.com/docs/native/customer-installations/installing-via-script/
# https://github.com/replicatedhq/replicated/releases
cd /tmp
curl -o install.sh -sSL https://raw.githubusercontent.com/replicatedhq/replicated/master/install.sh?replicated_tag=2.3.2
bash ./install.sh
rm -f install.sh
replicated version
