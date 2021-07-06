provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
}
