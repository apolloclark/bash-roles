#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# initialize
. ./init.sh

# https://www.terraform.io/docs/providers/tfe/r/oauth_client.html
# https://www.terraform.io/docs/cloud/vcs/github.html
