source ../env.sh
terraform init && terraform apply -parallelism=1 # creates resources defined in main.tf


# terraform show