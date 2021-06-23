# ---------------------------------------------------------------------------------------------------------------------
# Secret Manager SA with read and write access
# ---------------------------------------------------------------------------------------------------------------------
module "service_account" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account"

  name                  = "${terraform.workspace}-creds-refresher-sa"
  project               = var.env_project
  description           = "Creds Refresher ${terraform.workspace} service account"
  service_account_roles = ["roles/secretmanager.admin"]
}

resource "google_service_account_key" "platform" {
  service_account_id = module.service_account.email
}
