terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.7"
  backend "gcs" {
    bucket = "storyscript-ci-terraform"
    prefix = "pages-ci-terraform-state"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "google" {
  credentials = var.credentials
  version     = "~> 3.4.0"
  project     = "storyscript-ci"
  region      = "us-east4"
}

provider "google-beta" {
  credentials = var.credentials
  version     = "~> 3.4.0"
  project     = "storyscript-ci"
  region      = "us-east4"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

module "load-balancer_http-load-balancer" {
  source  = "gruntwork-io/load-balancer/google//modules/http-load-balancer"
  version = "0.2.0"
  project     = "storyscript-ci"
  name                  = "pages-ci"
  url_map               = google_compute_url_map.urlmap.self_link

  enable_ssl = true

  create_dns_entries = true
  dns_managed_zone_name = "storyscript-ci"
  custom_domain_names = ["pages-ci.storyscript-ci.com"]

  enable_http = false
  ssl_certificates = [google_compute_ssl_certificate.storyscript-ci.self_link]
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE DNS RECORDS FOR OTHER DOMAINS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "story-pages" {
  name = "demo.story.page."
  type = "A"
  ttl  = 300

  managed_zone = "story-page"
  rrdatas      = [module.load-balancer_http-load-balancer.load_balancer_ip_address]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SSL CERT
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_ssl_certificate" "storyscript-ci" {
  name_prefix = "storyscript-ci"
  description = "the cert for storyscript-ci.com and subdomains"

  // YOU WILL NEED TO GET THE CERTS ON DISK IF YOU ARE CREATING THIS RESOURCE FROM SCRATCH
  private_key = file("/tmp/privkey.pem")
  certificate = file("/tmp/cacert.pem")

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# CREATE THE URL MAP TO MAP PATHS TO BACKENDS
# ------------------------------------------------------------------------------

resource "google_compute_url_map" "urlmap" {
  name        = "pages-ci-url-map"
  description = "URL map for pages-ci"

  default_service = google_compute_backend_bucket.pages-ci.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }

  path_matcher {
    name            = "all"
    default_service = google_compute_backend_bucket.pages-ci.self_link
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A BACKEND BUCKET FROM THE GCS BUCKET TO SERVE VIA LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket" "storyscript_pages_ci" {
  name     = "storyscript-pages-ci-artifacts"
  location = "EU"
  storage_class = "STANDARD"

  // true = Destroys bucket even if there are objects in it
  // I'd rather we think about this before accidentally deleting all past built artifacts
  force_destroy = false

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_binding" "pages-ci-binding" {
  bucket = google_storage_bucket.storyscript_pages_ci.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}

resource "google_compute_backend_bucket" "pages-ci" {
  name        = "storyscript-pages-ci-artifacts"
  description = "Serves artifacts built by pages-ci"
  bucket_name = google_storage_bucket.storyscript_pages_ci.name
  enable_cdn  = false
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CUSTOM SERVICE ACCOUNT FOR UPLOADING PAGES ARTIFACTS
# ---------------------------------------------------------------------------------------------------------------------

module "gke_service_account" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account"
  project     = "storyscript-ci"

  name                  = "pages-ci-gh-action-sa"
  description           = "pages ci gh action service account"
  service_account_roles = ["roles/storage.objectAdmin"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A KEY FOR THE SERVICE ACCOUNT
# ---------------------------------------------------------------------------------------------------------------------

resource "google_service_account_key" "pages-ci-gh-actions" {
  service_account_id = module.gke_service_account.email
}

output "service_account_key" {
  description = "Account key to provide to GitHub actions"
  value       = base64decode(google_service_account_key.pages-ci-gh-actions.private_key)
}

