# ---------------------------------------------------------------------------------------------------------------------
# Secret Manager SA with read access
# ---------------------------------------------------------------------------------------------------------------------
module "service_account" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account"

  name                  = "${var.env_name}-${terraform.workspace}-sm-sa"
  project               = var.env_project
  description           = "Storytime ${terraform.workspace} service account"
  service_account_roles = ["roles/secretmanager.secretAccessor", "roles/secretmanager.secretVersionManager"]
}

resource "google_service_account_key" "platform" {
  service_account_id = module.service_account.email
}
