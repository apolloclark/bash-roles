#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/



# initialize
. ./init.sh



# https://www.terraform.io/docs/cloud/api/plans.html#show-a-plan
CURRENT_USER_RESPONSE=$(curl -sSLk --request GET \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/account/details
);
echo "${CURRENT_USER_RESPONSE}" | jq '.';
ADMIN_USERNAME=$(echo "${CURRENT_USER_RESPONSE}" | jq -r '.data.attributes.username');
echo "${ADMIN_USERNAME}";
ADMIN_EMAIL=$(echo "${CURRENT_USER_RESPONSE}" | jq -r '.data.attributes.email');
echo "${ADMIN_EMAIL}";



# list current User
# https://www.terraform.io/docs/cloud/api/account.html#get-your-account-details
CURRENT_USER_RESPONSE=$(curl -sSLk --request GET \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/vnd.api+json" \
  https://${TFE_HOSTNAME}/api/v2/account/details
);
echo "${CURRENT_USER_RESPONSE}" | jq '.';
ADMIN_USERNAME=$(echo "${CURRENT_USER_RESPONSE}" | jq -r '.data.attributes.username');
echo "${ADMIN_USERNAME}";
ADMIN_EMAIL=$(echo "${CURRENT_USER_RESPONSE}" | jq -r '.data.attributes.email');
echo "${ADMIN_EMAIL}";

# list existing Organizations
# https://www.terraform.io/docs/cloud/api/organizations.html#list-organizations
echo "[INFO] List Organizations...";
curl -sSLk --request GET \
  -H "Authorization: Bearer ${TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  https://${TFE_HOSTNAME}/api/v2/organizations | jq '.'

# crete an organization
# https://www.terraform.io/docs/cloud/api/organizations.html#create-an-organization
echo "[INFO] Create Organization";
ORG_POST_DATA=$(cat <<EOF
{
  "data": {
    "type": "organizations",
    "attributes": {
      "name": "testOrg",
      "email": "${ADMIN_EMAIL}"
    }
  }
}
EOF
);
CREATE_ORG_RESPONSE=$(curl -sSlk --request POST \
  -H "Authorization: Bearer ${TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  --data "${ORG_POST_DATA}" \
  https://${TFE_HOSTNAME}/api/v2/organizations
);
echo "${CREATE_ORG_RESPONSE}" | jq '.';

# list existing Organizations
# https://www.terraform.io/docs/cloud/api/organizations.html#list-organizations
echo "[INFO] List Organizations...";
curl -sSLk --request GET \
  -H "Authorization: Bearer ${TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  -c session_cookies.txt \
  -b session_cookies.txt \
  https://${TFE_HOSTNAME}/api/v2/organizations | jq '.'


