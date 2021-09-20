#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# set configuration variables

# https://docs.docker.com/engine/release-notes/

# https://release-notes.replicated.com/
# replicated requires the Docker minimum version '1.7.1', released on 2015-07-14
# replicated will by default install Docker version '18.09.2', released 2019-02-11
# https://docs.docker.com/engine/release-notes/

# RHEL 7, docker 1.13, relased 2017-01-01
# https://www.docker.com/blog/whats-new-in-docker-1-13/

# RHEL 7 'docker-latest' package, 'rhel-7-server-extras-rpms' repo, released 2018-03-19
# https://centos.pkgs.org/7/centos-extras-x86_64/docker-latest-1.13.1-58.git87f2fab.el7.centos.x86_64.rpm.html#changelog
# export DOCKER_VERSION="1.13.1-58.git87f2fab"

# RHEL 7 'docker-common' package, 'rhel-7-server-extras-rpms' repo, released 2019-10-16
# https://bugzilla.redhat.com/show_bug.cgi?id=1739315
# export DOCKER_VERSION="1.13.1-104.git4ef4b30.el7"

# yum list installed 'docker*'



# RHEL / CentOS 7 'docker-ce' package, 'docker-ce-stable' repo, released 2018-02-27
# https://docs.docker.com/engine/release-notes/#17121-ce
# export DOCKER_VERSION="17.12.1.ce"

# RHEL / CentOS 7 'docker-ce' package, 'docker-ce-stable' repo, released 2019-02-11
# https://docs.docker.com/engine/release-notes/#18092
# export DOCKER_VERSION="18.09.2"

# RHEL / CentOS 7 'docker-ce' package, 'docker-ce-stable' repo, released 2019-09-03
# https://docs.docker.com/engine/release-notes/#18099
# export DOCKER_VERSION="18.09.9"

# Oracle Linux 7 'docker-engine' package, 'ol7_addons' repo, released 2019-12-05
# https://linux.oracle.com/errata/ELSA-2019-4827.html
# export DOCKER_VERSION="19.03.1.ol"



# Ubuntu / RHEL / CentOS 'docker-ce' package, 'docker-ce-stable' repo, released 2019-11-14
# https://docs.docker.com/engine/release-notes/
# export DOCKER_VERSION="1.13.1-108.git4ef4b30.el7"
# export DOCKER_PACKAGE="docker-common"
# export DOCKER_CLI_PACKAGE="docker-client"
export DOCKER_VERSION="19.03.11"
# curl -sSLk https://docs.docker.com/engine/release-notes/ | grep -E '^<h2 id=".*">.*</h2>' | head -n1 | egrep -o "([0-9]{1,}\.)+[0-9]{1,}"
export DOCKER_PACKAGE="docker-ce"
export DOCKER_CLI_PACKAGE="docker-ce-cli"

# (optional) these variables will be auto-configured later, within get-distro.sh script
export DISTRO_OS="";
export DISTRO_VERSION="";
export DISTRO_VERSION_MAJOR="";

# (optional), configured by Vagrant, as positional variables when calling bootstrap.sh
export REDHAT_USER="";
export REDHAT_PASS="";

# (optional) TFE
# https://github.com/hashicorp/terraform-enterprise-release-notes
export TFE_RELEASE="439"
export TFE_HOSTNAME='tfe-demo'
export TFE_LICENSE_VERSION='apollo-v4'
export PRIVATE_IP_ADDR='10.0.2.15' # this is the default vbox guest IP
export REPLICATED_PASSWORD='ptfe-pwd'
export REPLICATED_VERSION=""; # defaults to latest version

# (optional) ELK
# https://github.com/elastic/elasticsearch/releases
export ELK_VERSION="7.8.0"

# packages to install
export PACKAGES=("base" "jq" "terraform" "packer" "docker" "tfe" "docker-elk"); # build TFE w/ ELK Logging, 21 min 14 sec
