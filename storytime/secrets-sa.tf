# ---------------------------------------------------------------------------------------------------------------------
# Secret Manager SA with read access
# ---------------------------------------------------------------------------------------------------------------------
module "service_account" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account"

  name                  = "${var.app_name}-${var.app_environment}-sm-sa"
  project               = var.app_project
  description           = "Storytime ${var.app_environment} service account"
  service_account_roles = ["roles/secretmanager.secretAccessor", "roles/secretmanager.secretVersionManager"]
}

resource "google_service_account_key" "platform" {
  service_account_id = module.service_account.email
}
