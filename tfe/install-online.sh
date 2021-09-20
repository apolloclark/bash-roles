#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  

curl -sSL https://install.terraform.io/ptfe/stable | bash -s no-ce-on-ee
