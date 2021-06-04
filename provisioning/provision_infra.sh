echo "=== CLONING TERRAFORM MODULE ==="

git clone https://github.com/mikenomitch/terraform-aws-hashistack.git ./stacks/tmp/hashistack
cd ./stacks/tmp/hashistack

echo "=== WRITING TF VARS FILE ==="
# Thread them in
# Echo them out
# Pass them to the tf apply command
echo "TODO: THREAD IN THE INPUTS"

echo "=== BUILDING TF BACKEND CONFIG ==="
# Thread them in
# Echo them out
# Write the file from a template that exists in the repo
echo "TODO: THREAD IN S3 BUCKET INTO A CONFIG FILE"

echo "=== INITIALIZING TERRAFORM ==="
# Thread them in
echo "TODO: REPLACE ENVCHAIN WITH THE VALUES FROM THE INPUTS"

terraform init
terraform apply --auto-approve
