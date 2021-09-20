# bash-roles

This is a collection of Bash scripts, but written like Ansible Roles. Bash, written by Brian Fox in 1989 for the GNU Project, is an acronym for "Bourne Again Shell". The Bourne Shell was was created in 1978, and borrows many ideas from ALGOL68C. Bash has become the defacto standard for Linux, Android, macOS, iOS, and many other platforms. However, more robust and reliable configuration management tools have been created such as Ansible, Puppet, Chef, Saltstack, CFEngine, etc. This repo is created to bring the ideas of idempotency, atomicity, and reliabilty from more modern configuration management tools to Bash. These Bash scripts are written to follow Strict Bash and to fail early. By default, scripts will attempt to install the latest available version of a package, but you can explicitely version pin as well. These scripts are tested to be compatible with: Ubuntu, Debian, RHEL, CentOS, Oracle Linux, and Amazon Linux 2.

Links:
- https://en.wikipedia.org/wiki/Bash_(Unix_shell)
- https://en.wikipedia.org/wiki/Bourne_shell
- https://en.wikipedia.org/wiki/Ansible_(software)



# Getting Started

```shell
git clone https://github.com/apolloclark/bash-roles
cd ./bash-roles
. ./bootstrap.sh
```

The best way to use this collection of scripts is to create a folder within your Git repo projects called "provision", and add a files within that folder called "install.sh" and another file called "variables.sh"

```shell
[variables.sh]
#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# set configuration variables

# https://github.com/hashicorp/vault/blob/master/CHANGELOG.md
export VAULT_VERSION="1.7.2" # released 2021-04-20
export VAULT_PACKAGE="vault" # vault, vault-enterpise

# (optional) these variables will be auto-configured later, within get-distro.sh script
export DISTRO_OS="";
export DISTRO_VERSION="";
export DISTRO_VERSION_MAJOR="";

# (optional), configured by Vagrant, as positional variables when calling bootstrap.sh
export REDHAT_USER="";
export REDHAT_PASS="";

# packages to install
export PACKAGES=("base" "jq" "vault-oss");





[install.sh]
#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

. ./variables.sh
git clone https://github.com/apolloclark/bash-roles
. ./bootstrap.sh

```