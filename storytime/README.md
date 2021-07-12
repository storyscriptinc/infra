# Deploying GCP VMs located in a private subnet, inside an unmanaged instance group, with a load balancer using Terraform

```bash
$> terrafrom login

$> terraform init

# This is going to use remote variables and machine to run the plan/apply
$> terraform plan

# At this point it will either target the proper workspace (if set before), or ask you to choose one from TFCloud

# To create a new workspace, you can run
$> terraform workspace new storytime-<name>
# then head up to https://app.terraform.io/app/storyai/workspaces/storytime-<name>/settings/general
# and change the execution mode to `local`
```

The script will install 1 instance with storytime docker container located in private subnet, without public ip, inside an unmanaged instance group, with a load balancer using Terraform.

lb-unmanaged.tf --> Create unmanaged instance group, backend services and all components required by the load balancer 

network-firewall.tf --> Configure basic firewall for the network

network-variables.tf --> Define network variables

network.tf --> Define network, vpc, subnet, icmp firewall

provider.tf --> Configure Google Cloud provider

terraform.tfvars --> Defining variables 

variables-auth.tf --> Application and authentication variables

vm.tf --> Create 1 VM with storytime container

# Notes

Check list of Google Cloud OS images --> https://cloud.google.com/compute/docs/images

Create the Json file for authentication --> https://cloud.google.com/iam/docs/creating-managing-service-account-keys

Read the post for the repo --> https://medium.com/@gmusumeci/getting-started-with-terraform-and-google-cloud-platform-gcp-deploying-vms-in-a-private-only-f9ab61fa7d15
