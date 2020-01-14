#### What is this for?

This repo contains terraform scripts that describe the infrastructure that we run in storyscript.

#### How to use?

1. Get a service account key with sufficient privileges (at least DNS and GCS)
2. Set `GOOGLE_CREDENTIALS` to target the file containing that key
3. Set `TF_VAR_credentials` to the contents of the file containing that key
4. Run `terraform init` from the directory containing the terraform scripts you want to run
5. Run `terraform plan` to see if there are any changes

Terraform stores the state of the infrastructure against which to converge in GCS
