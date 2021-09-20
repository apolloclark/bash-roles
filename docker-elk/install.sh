#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# set default values, if not defined
if [[ -z "${ELK_VERSION-}" ]]; then
  export ELK_VERSION="7.8.0"
fi



# install CentOS version
# Docker requires a linux kernel 3.10+, CentOS 6.x uses 2.6, and CentOS 8.x
# uses Podman.
if [ "$DISTRO_OS" == "centos" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -ne "7" ]; then
    echo "[ERROR] CentOS 6.x and 8.x do not support Docker."
    exit 1;
  fi
  . ./install-centos.sh
fi

# install RHEL version (uses the CentOS repo)
# Docker requires a linux kernel 3.10+, RHEL 6.x uses 2.6, and RHEL 8.x
# uses Podman.
if [ "$DISTRO_OS" == "rhel" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -ne "7" ]; then
    echo "[ERROR] RHEL 6.x and 8.x do not support Docker."
    exit 1;
  fi
  . ./install-centos.sh
fi

# install Ubuntu version
if [ "$DISTRO_OS" == "ubuntu" ]; then
  if [ "$DISTRO_VERSION_MAJOR" -lt "16" ]; then
    echo "[ERROR] Ubuntu 14.04 went End of Life (EOL) on April 30, 2019."
    exit 1;
  fi
  . ./install-ubuntu.sh
fi



# startup
docker-compose up -d

echo "[INFO] Waiting 2.5 min / 150 seconds for ELK to initialize..."
sleep 150

# wait for Kibana to become active, grab the response headers
# curl -sSLk http://localhost:5601/api/status | jq '.status.overall.state' | grep 'green'
while ! curl -sSLk http://localhost:5601/api/status | jq '.status.overall.state' | grep 'green' 2>&1 > /dev/null; do
    echo "[INFO] waiting for Kibana to startup..."
    sleep 10
done

# send an initla log entry
if [ "$DISTRO_OS" == "ubuntu" ]; then
  echo "[INFO] Initializing Logstash..." | nc -q0 localhost 5000
fi
if [ "$DISTRO_OS" == "rhel" ]; then
  echo "[INFO] Initializing Logstash..." | nc localhost 5000
fi
if [ "$DISTRO_OS" == "centos" ]; then
  echo "[INFO] Initializing Logstash..." | nc localhost 5000
fi


# auto-configure "logstash-*" as the default index
curl -sSLk -XPOST -D- 'http://127.0.0.1:5601/api/saved_objects/index-pattern' \
    -H 'Content-Type: application/json' \
    -H "kbn-version: ${ELK_VERSION}" \
    -d '{"attributes":{"title":"logstash-*","timeFieldName":"@timestamp"}}'

# start logspout
docker run -d --name="logspout" \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --link=dockerelk_logstash_1 \
  gliderlabs/logspout \
  syslog+tcp://logstash:5000
