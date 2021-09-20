#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  

# register with Redhat
subscription-manager register --username "$REDHAT_USER" --password "$REDHAT_PASS"

# list available subscriptions
subscription-manager list --available --all
export RHEL_SUB=$(subscription-manager list --available --all | grep 'Pool' | cut -b 22-);

# delete old subscriptions:
# https://access.redhat.com/management/systems

# register with self-serve virtual subscription
subscription-manager subscribe --pool=${RHEL_SUB}

# apply security updates
echo "Installing updates, takes a few minutes..."
yum update-minimal --security -y -e 0 > /dev/null

# enable extra repos
subscription-manager repos --enable=rhel-7-server-rpms
subscription-manager repos --enable=rhel-7-server-extras-rpms
subscription-manager repos --enable=rhel-7-server-optional-rpms
