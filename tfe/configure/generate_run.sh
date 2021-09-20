# create the Run / terraform init
# crete an organization
# https://www.terraform.io/docs/cloud/api/organizations.html#create-an-organization
echo "[INFO] Create a Run";
RUN_DATA=$(cat <<EOF
{
  "data": {
    "attributes": {
      "is-destroy": false,
      "message": "Custom message",
      "target-addrs": ["example.resource_address"]
    },
    "type":"runs",
    "relationships": {
      "workspace": {
        "data": {
          "type": "workspaces",
          "id": "ws-1fofPfEHqXk1UJsb"
        }
      },
      "configuration-version": {
        "data": {
          "type": "configuration-versions",
          "id": "cv-n4XQPBa2QnecZJ4G"
        }
      }
    }
  }
}
EOF
);
RUN_RESPONSE=$(curl -sSlk --request POST \
  -H "Authorization: Bearer ${TOKEN}" \
  -H 'Content-Type: application/vnd.api+json' \
  --data "${RUN_DATA}" \
  https://${TFE_HOSTNAME}/api/v2/runs
);
echo "${RUN_RESPONSE}" | jq '.';



# check the Plan status / terraform apply






exit 0;