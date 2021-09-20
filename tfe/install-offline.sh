#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/ 



# set default values, if not defined
if [[ -z "${PRIVATE_IP_ADDR-}" ]]; then
  PRIVATE_IP_ADDR="10.0.2.15"
fi
if [[ -z "${TFE_RELEASE-}" ]]; then
  TFE_RELEASE="423"
fi
if [[ -z "${TFE_HOSTNAME-}" ]]; then
  TFE_HOSTNAME="tfe-demo"
fi
if [[ -z "${TFE_LICENSE_VERSION-}" ]]; then
  TFE_LICENSE_VERSION="apollo-v4"
fi
if [[ -z "${REPLICATED_PASSWORD-}" ]]; then
  REPLICATED_PASSWORD="ptfe-pwd"
fi



# -----------------------------------------------------------------------------
# TFE Install (Automated Airgapped)
# -----------------------------------------------------------------------------

# turn off the firewall
service firewalld stop || true
 
# set se-linux into permissive mode, which is basically disabled without a reboot
echo 0 > /sys/fs/selinux/enforce || true
getenforce || true



# generate self-signed cert, must match hostname
# may need to spoof vbox DNS...
cd /tmp
openssl req -x509 -newkey rsa:4096 -keyout key.pem -nodes -out cert.pem \
  -days 365 -subj '/CN='${TFE_HOSTNAME}'/O=HashiCorp/C=US' > /dev/null

# verify the cert
openssl x509 -text -noout -in cert.pem

# move the cert, set permissions
cp ./*.pem /etc/
chmod 0600 /etc/*.pem
ls -lah /etc | grep pem



# configure the Docker DNS lookup
tee /etc/docker/daemon.json <<EOF
{ "dns": ["127.0.0.1"] }
EOF
service docker restart

# ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
# nslookup "${TFE_HOSTNAME}"



# Write out replicated.conf configuration file
# https://www.terraform.io/docs/enterprise/install/automating-the-installer.html#airgapped
# https://help.replicated.com/docs/native/customer-installations/automating/
tee /etc/replicated.conf <<EOF
{
  "DaemonAuthenticationType": "password",
  "DaemonAuthenticationPassword": "${REPLICATED_PASSWORD}",
  "TlsBootstrapType": "self-signed",
  "LogLevel": "debug",
  "ImportSettingsFrom": "/tmp/replicated-settings.json",
  "LicenseFileLocation": "/tmp/license.rli",
  "LicenseBootstrapAirgapPackagePath": "/tmp/bundle.airgap",
  "BypassPreflightChecks": true
}
EOF

# Write out TFE settings file
# https://www.terraform.io/docs/enterprise/install/automating-the-installer.html#application-settings
# https://www.terraform.io/docs/enterprise/install/automating-the-installer.html#available-settings
tee /tmp/replicated-settings.json <<EOF
{
    "hostname": {
        "value": "${TFE_HOSTNAME}"
    },
    "installation_type": {
        "value": "poc"
    },
    "capacity_concurrency": {
        "value": "3"
    }
}
EOF

# copy install files shared from the Host into the Guest VM
cp /vagrant_data/hashicorp-employee-${TFE_LICENSE_VERSION}.rli /tmp/license.rli
cp /vagrant_data/Terraform\ Enterprise\ -\ ${TFE_RELEASE}.airgap /tmp/bundle.airgap
cp /vagrant_data/replicated.tar.gz /tmp/replicated.tar.gz



# Make sure files used by the installer are readable by all
# chmod a+r /etc/replicated.conf
# chmod a+r /tmp/replicated-settings.json
# chmod a+r /tmp/license.rli
# chmod a+r /tmp/bundle.airgap

# Validate JSON syntax of configuration files
# (it should just cat back out each file, no other messages)
python -m json.tool /etc/replicated.conf
python -m json.tool /tmp/replicated-settings.json



# extract the installer
cd /tmp
tar xzf replicated.tar.gz
# exit 0;





# Run automated airgap installer
cd /tmp
./install.sh \
    airgap \
    no-proxy \
    private-address=${PRIVATE_IP_ADDR} \
    public-address=${PRIVATE_IP_ADDR}

# enable the systemd services
# https://help.replicated.com/docs/native/customer-installations/installing-via-script/
# https://help.replicated.com/docs/native/customer-installations/installing-via-script/#restarting-replicated
systemctl enable replicated replicated-ui replicated-operator
systemctl restart replicated replicated-operator replicated-ui



# Wait for the Replicated health check to be ready

# wait for Replicated to startup
echo "[INFO] Sleeping for 12 min / 720 seconds, to wait for Replicated to startup..."
sleep 720
i=0;
while ! curl -sSkf -w "%{http_code}" --connect-timeout 5 https://127.0.0.1:8800 2>&1 > /dev/null; do
    sleep 10
    echo "[INFO] waiting for Replicated to startup..."
    ((i++))
    if [[ "$i" -gt "60" ]]; then
      echo "[ERROR] Replicated has taken more than 60 seconds to active, check logs."
      exit 1;
    fi
done
echo "[INFO] Replicated is now active! Go to https://tfe-demo:8800"

# wait for TFE to startup
echo "[INFO] Sleeping for 2 min / 120 seconds, to wait for TFE to startup..."
sleep 120
i=0;
while ! curl -sSkf -w "%{http_code}" --connect-timeout 5 https://127.0.0.1/_health_check 2>&1 > /dev/null; do
    sleep 10
    echo "[INFO] waiting for TFE to startup..."
    ((i++))
    if [[ "$i" -gt "60" ]]; then
      echo "[ERROR] TFE has taken more than 60 seconds to active, check logs."
      exit 1;
    fi
done
echo "[INFO] TFE is now active! Go to https://tfe-demo:4443/session"
