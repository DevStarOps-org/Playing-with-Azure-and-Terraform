cd ..
terraform init -reconfigure -var-file="envs/local.tfvars" -backend-config="envs/local.tfbackend"
terraform apply -destroy -auto-approve -input=false -var-file="envs/local.tfvars"

terraform init -reconfigure -var-file="envs/test.tfvars" -backend-config="envs/test.tfbackend"
terraform apply -destroy -auto-approve -input=false -var-file="envs/test.tfvars"

terraform init -reconfigure -var-file="envs/production.tfvars" -backend-config="envs/production.tfbackend"
terraform apply -destroy -auto-approve -input=false -var-file="envs/production.tfvars"

$SharedResourceGroup = "ugdemo-shared-rg"
az group delete --resource-group $SharedResourceGroup --yes
cd scripts