echo "=== PARSING ARGS ==="

KEY=$1
SECRET_KEY=$2
CLUSTER_NAME=$3
REGION=$4

echo $REGION
echo $CLUSTER_NAME

printf '^^^^^^^^^^'
printf '{"nomad_token":"%s","consul_token":"%s","nomad_addr":"%s","consul_addr":"%s"}' "$REGION" "$CLUSTER_NAME" "$CLUSTER_NAME" "$CLUSTER_NAME"