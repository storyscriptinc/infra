# setup the GCP provider | provider.tf

terraform {
  required_version = ">= 1.0.0"
}

provider "google" {
  project     = var.env_project
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region_1
  zone        = var.gcp_zone_1
}

provider "google-beta" {
  project     = var.env_project
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region_1
  zone        = var.gcp_zone_1
}
