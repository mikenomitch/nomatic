echo "=== POST-PROVISIONING SET UP ==="

echo "=== PARSING ARGS ==="

KEY=$1
SECRET_KEY=$2
CLUSTER_NAME=$3
REGION=$4

echo "=== CLONING TERRAFORM MODULE ==="

CLUSTER_PATH=./deprovision-tmp/$CLUSTER_NAME

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

echo "=== DESTROYING ==="

terraform destroy -auto-approve