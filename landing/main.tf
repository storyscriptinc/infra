terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.7"
  backend "gcs" {
    bucket = "storyscript-infra"
    prefix  = "landing/state"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "google" {
  credentials = var.credentials
  version = "~> 2.9.0"
  project = "storyscript"
  region  = "us-east4"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE DNS RECORDS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscri-pt-apex" {
  name = "storyscri.pt."
  type = "A"
  ttl = 300

  managed_zone = "storyscri-pt"
  rrdatas = [ "104.198.14.52" ]
}


resource "google_dns_record_set" "storyscri-pt-www" {
  name = "www.storyscri.pt."
  type = "CNAME"
  ttl = 300

  managed_zone = "storyscri-pt"
  rrdatas = [ "storyscri.pt." ]
}
