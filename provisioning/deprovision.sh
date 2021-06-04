echo "=== REMOVING HASHISTACK ==="

cd ./stacks/tmp/hashistack
envchain personal terraform destroy --auto-approve
