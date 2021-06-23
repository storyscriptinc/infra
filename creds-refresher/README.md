## Creds Refresher

This set of Terraform scripts exists to stand up the [creds refresher](https://github.com/storyai/creds-refresher) in GCP.

The pieces that are created:

- A Virtual Private Network with a Subnet and some firewall rules
- A Service Account with Key that has permissions to manage Secrets in Secret Manager
- A VM running GCP Container-OS with the creds-refresher docker image in it

### Running

```
env TF_VAR_gcp_auth_file=<file location> TF_VAR_gcp_region_1=europe-west2 TF_VAR_gcp_zone_1=europe-west2-c TF_VAR_private_subnet_cidr_1="10.10.1.0/24" terraform apply
```
