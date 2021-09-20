#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# initialize
. ./init.sh



# retrieve initial CSRF token
echo "[INFO] retrieve CSRF Token...";
CSRF_TOKEN=$(curl -sSLk https://${TFE_HOSTNAME}/session | grep -F 'csrf-token' | cut -d '"' -f4);
echo "[INFO] CSRF_TOKEN = ${CSRF_TOKEN}";

ADMIN_USERNAME="admin$(date +%s)";
ADMIN_PASSWORD="correcthorsebatterystaple";
ADMIN_EMAIL="${ADMIN_USERNAME}@test.com"
ADMIN_POST_DATA=$(cat <<EOF
{
  "data": {
    "attributes": {
      "username": "${ADMIN_USERNAME}",
      "email": "${ADMIN_EMAIL}",
      "password": "${ADMIN_PASSWORD}"
    }
  }
}
EOF
);

# create a new TFE Admin User
echo "[INFO] Create new Admin User...";
ADMIN_DATA=$(curl -sSlk --request POST \
  -H "X-CSRF-Token: ${CSRF_TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -c session_cookies.txt \
  --data "${ADMIN_POST_DATA}" \
  https://${TFE_HOSTNAME}/api/v2/account/create
);
echo "$ADMIN_DATA" | jq '.' > /dev/null
ADMIN_USERID=$(echo "$ADMIN_DATA" | jq '.data.id' | tr -d '"');
echo "[INFO] ADMIN_USERID = ${ADMIN_USERID}";

# get Organization Entitlement
echo "[INFO] Get Org Entitlement...";
curl -sSLk --request GET \
  -H "X-CSRF-Token: ${CSRF_TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -H 'Accept: application/vnd.api+json' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  https://${TFE_HOSTNAME}/api/v2/organizations?include=entitlement_set | jq '.' > /dev/null

# get account details
echo "[INFO] Get Account Details...";
curl -sSLk --request GET \
  -H "X-CSRF-Token: ${CSRF_TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  https://${TFE_HOSTNAME}/api/v2/account/details | jq '.' > /dev/null

# list User tokens
echo "[INFO] List User Tokens...";
curl -sSLk --request GET \
  -H "X-CSRF-Token: ${CSRF_TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  https://${TFE_HOSTNAME}/api/v2/users/${ADMIN_USERID}/authentication-tokens | jq '.'

# retrieve new CSRF Token
echo "[INFO] retrieve new CSRF Token";
CSRF_TOKEN=$(curl -sSLk \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  https://${TFE_HOSTNAME}/app/settings/tokens \
  | grep -F 'csrf-token' | cut -d '"' -f4
);
echo "[INFO] CSRF_TOKEN = ${CSRF_TOKEN}";

# create a new User Token
# https://www.terraform.io/docs/cloud/api/user-tokens.html#create-a-user-token
echo "[INFO] Create Admin Token";
ADMIN_TOKEN_RESPONSE=$(curl -sSlk --request POST \
  -H "X-CSRF-Token: ${CSRF_TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -H 'Accept: application/vnd.api+json' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  --data '{"data":{"attributes":{"description":"admin token"}}}' \
  https://${TFE_HOSTNAME}/api/v2/users/${ADMIN_USERID}/authentication-tokens
);
export ADMIN_TOKEN=$(echo "$ADMIN_TOKEN_RESPONSE" | jq '.data.attributes.token' | tr -d '"');
echo "[INFO] ADMIN_TOKEN = ${ADMIN_TOKEN}";

# list User tokens
# https://www.terraform.io/docs/cloud/api/user-tokens.html#list-user-tokens
echo "[INFO] List Auth Tokens...";
curl -sSLk --request GET \
  -H "X-CSRF-Token: ${CSRF_TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  https://${TFE_HOSTNAME}/api/v2/users/${ADMIN_USERID}/authentication-tokens | jq '.'

# show User Token
# https://www.terraform.io/docs/cloud/api/user-tokens.html#show-a-user-token
