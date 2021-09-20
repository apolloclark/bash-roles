#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/





# save the current time
GLOBAL_START=`date +%s`

# set the installer directory
PROJECT_DIR="/vagrant";
cd $PROJECT_DIR;

# change into the scripts directory
ls -lah
whoami

# source variables
. ./variables.sh

# detect OS
. ./base/get-distro.sh
echo "DISTRO_OS = $DISTRO_OS"
echo "DISTRO_VERSION = $DISTRO_VERSION"
echo "DISTRO_VERSION_MAJOR = $DISTRO_VERSION_MAJOR"



# ensure the TFE .airgap file is present, if requested

# ensure the .rli TFE License file is present

# ensure the RHEL license variables are set, if deploying to RHEL
if [ "$DISTRO_OS" == "rhel" ]; then
  REDHAT_USER=${1:-}
  if [[ -z "$REDHAT_USER" ]]; then
    echo "ERROR: Missing <REDHAT_USER>, set the REDHAT_USER environment variable on your host machine."
    echo "usage: $0 <REDHAT_USER> <REDHAT_PASS>"
    exit 1
  fi

  REDHAT_PASS=${2:-}
  if [[ -z "$REDHAT_PASS" ]]; then
    echo "ERROR: Missing <REDHAT_PASS>, set the REDHAT_PASS environment variable on your host machine"
    echo "usage: $0 <REDHAT_USER>  <REDHAT_PASS>"
    exit 1
  fi

  echo "REDHAT_USER = $REDHAT_USER";
  echo "REDHAT_PASS = $REDHAT_PASS";
  
  # subscribe RHEL
  . ./base/subscribe-rhel.sh
fi



# install packages
for PACKAGE_NAME in ${PACKAGES[@]}; do
  cd $PROJECT_DIR/$PACKAGE_NAME
  . ./install.sh
done

# clean
cd $PROJECT_DIR
. ./base/clean.sh



# print total run-time
GLOBAL_END=`date +%s`
secs=$((GLOBAL_END-GLOBAL_START))
printf 'runtime = %02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
echo "[INFO] SUCCESS! Go to https://tfe-demo:4443/session"

exit 0;
