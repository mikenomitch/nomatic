echo "=== POST-PROVISIONING SET UP ==="

echo "=== PARSING ARGS ==="

KEY=$1
SECRET_KEY=$2
CLUSTER_NAME=$3
REGION=$4

echo "=== CLONING TERRAFORM MODULE ==="

CLUSTER_PATH=./post-provision-tmp/$CLUSTER_NAME

git clone https://github.com/mikenomitch/nomatic-stack.git $CLUSTER_PATH
cd $CLUSTER_PATH

echo "=== BUILDING TF BACKEND CONFIG ==="

BACKEND_CONFIG_PATH=./backend.tf

tee $BACKEND_CONFIG_PATH > /dev/null <<EOF
terraform {
  backend "s3" {}
}
EOF

echo "=== SETTING ACCESS KEYS ==="
export AWS_ACCESS_KEY_ID=$KEY
export AWS_SECRET_ACCESS_KEY=$SECRET_KEY

echo "=== INITIALIZING TERRAFORM ==="

terraform init \
    -backend-config="bucket=$CLUSTER_NAME-state" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=$REGION" \
    -backend-config="dynamodb_table=$CLUSTER_NAME-lock" \
    -backend-config="encrypt=true"

echo "=== GETTING URLS ==="

export NOMAD_ADDR=$(terraform output nomad_server_url | sed -e 's/^"//' -e 's/"$//')
export CONSUL_HTTP_ADDR=$(terraform output consul_server_url | sed -e 's/^"//' -e 's/"$//')
export NOMAD_CLIENT_ADDR=$(terraform output nomad_client_url | sed -e 's/^"//' -e 's/"$//')
export NOMAD_CLIENT_LB_ADDR=$(terraform output nomad_client_lb_url | sed -e 's/^"//' -e 's/"$//')
export VAULT_ADDR=$(terraform output vault_url | sed -e 's/^"//' -e 's/"$//')

echo "=== ENSURING HEALTHY ==="

# TODO: FIGURE OUT THE BEST WAY TO DO THIS!

echo "=== GETTING TOKENS ==="

export NOMAD_TOKEN=$(curl --request POST "$NOMAD_ADDR/v1/acl/bootstrap" | jq -r .SecretID)
export CONSUL_HTTP_TOKEN=$(curl --request PUT "$CONSUL_HTTP_ADDR/v1/acl/bootstrap" | jq -r .SecretID)

# TODO: Make this an API request instead of the worst thing ever.
printf '^^^^^^^^^^'
printf '{"nomad_token":"%s","consul_token":"%s","nomad_addr":"%s","consul_addr":"%s","nomad_client_addr":"%s","vault_addr":"%s"}' "$NOMAD_TOKEN" "$CONSUL_HTTP_TOKEN" "$NOMAD_ADDR" "$CONSUL_HTTP_ADDR" "$NOMAD_CLIENT_LB_ADDR" "$VAULT_ADDR"