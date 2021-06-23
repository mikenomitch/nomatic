echo "=== PARSING ARGS ==="

KEY=$1
SECRET_KEY=$2
CLUSTER_NAME=$3
REGION=$4

echo "KEY"
echo $KEY
echo "SECRET_KEY"
echo $SECRET_KEY
echo "CLUSTER_NAME"
echo $CLUSTER_NAME
echo "REGION"
echo $REGION

echo "=== CLONING TERRAFORM MODULE FOR STATE BUCKET ==="

CLUSTER_PATH=./pre-provision-tmp/$CLUSTER_NAME

git clone https://github.com/mikenomitch/nomatic-state-holder.git $CLUSTER_PATH
cd $CLUSTER_PATH

echo "=== SETTING ACCESS KEYS ==="
export AWS_ACCESS_KEY_ID=$KEY
export AWS_SECRET_ACCESS_KEY=$SECRET_KEY

echo "=== INITIALIZING TERRAFORM ==="

terraform init

echo "=== APPLYING TERRAFORM ==="

terraform apply -auto-approve -var region=$REGION -var name=$CLUSTER_NAME -var tag=$CLUSTER_NAME
