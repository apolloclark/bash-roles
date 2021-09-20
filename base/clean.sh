#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  

# Ubuntu
if [ "$DISTRO_OS" == "ubuntu" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -lt "16" ]; then
    echo "[ERROR] Ubuntu 14.04 went End of Life (EOL) on April 30, 2019."
    exit 1;
  fi
  apt-get autoremove -y
  apt-get clean -y

  # clear syslog
  rm -rf /var/log/*.log
fi

# clear Bash command history
history -c && history -w
