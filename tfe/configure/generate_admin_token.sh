#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# initialize
. ./init.sh



# https://www.terraform.io/docs/enterprise/install/automating-initial-user.html
INITIAL_TOKEN=$(replicated admin --tty=0 retrieve-iact)
echo "[INFO] INITIAL_TOKEN = ${INITIAL_TOKEN}"

ADMIN_USERNAME="admin$(date +%s)";
ADMIN_PASSWORD="correcthorsebatterystaple";
ADMIN_EMAIL="${ADMIN_USERNAME}@test.com"
ADMIN_POST_DATA=$(cat <<EOF
{
  "username": "${ADMIN_USERNAME}",
  "email": "${ADMIN_EMAIL}",
  "password": "${ADMIN_PASSWORD}"
}
EOF
);

ADMIN_TOKEN_RESPONSE=$(curl -sSLk \
  --request POST \
  -H "Content-Type: application/json" \
  --data "${ADMIN_POST_DATA}" \
  https://${TFE_HOSTNAME-}/admin/initial-admin-user?token=${INITIAL_TOKEN} \
  | jq '.'
);
echo "${ADMIN_TOKEN_RESPONSE}";
export ADMIN_TOKEN=$(echo "${ADMIN_TOKEN_RESPONSE}" | jq '.token' | tr -d '"');
echo "[INFO] ADMIN_TOKEN = ${ADMIN_TOKEN}"
