terraform {
  required_version = ">= 1.0.0"
  backend "remote" {
    organization = "storyai"

    workspaces {
      name = "story-ai-app"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "google" {
  credentials = var.credentials
  project     = "storyscript"
  region      = "us-east4"
}

provider "google-beta" {
  credentials = var.credentials
  project     = "storyscript"
  region      = "us-east4"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

module "load-balancer_http-load-balancer" {
  source  = "gruntwork-io/load-balancer/google//modules/http-load-balancer"
  version = "0.4.0"
  project = "storyscript"
  name    = "story-ai-app"
  url_map = google_compute_url_map.story-ai-app.self_link

  enable_ssl = true

  create_dns_entries    = true
  dns_managed_zone_name = "story-ai"
  custom_domain_names   = ["app.story.ai"]

  enable_http      = false
  ssl_certificates = [google_compute_ssl_certificate.story-ai-app.self_link]
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE SSL CERT
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_ssl_certificate" "story-ai-app" {
  name_prefix = "story-ai-app"
  description = "the cert for story.ai and subdomains"

  // YOU WILL NEED TO GET THE CERTS ON DISK IF YOU ARE CREATING THIS RESOURCE FROM SCRATCH
  private_key = file(var.cert_privkey)
  certificate = file(var.cert_fullchain)

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# CREATE THE URL MAP TO MAP PATHS TO BACKENDS
# ------------------------------------------------------------------------------

resource "google_compute_url_map" "story-ai-app" {
  name        = "story-ai-app-url-map"
  description = "URL map for story-ai"

  default_service = google_compute_backend_bucket.story-ai-app.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }

  path_matcher {
    name            = "all"
    default_service = google_compute_backend_bucket.story-ai-app.self_link
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A BACKEND BUCKET FROM THE GCS BUCKET TO SERVE VIA LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket" "story-ai-app" {
  name          = "story-ai-app"
  location      = "EU"
  storage_class = "STANDARD"

  // true = Destroys bucket even if there are objects in it
  force_destroy = false

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_binding" "story-ai-app" {
  bucket = google_storage_bucket.story-ai-app.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}

resource "google_compute_backend_bucket" "story-ai-app" {
  name        = "story-ai-app"
  description = "Serves the stable app.story.ai resource"
  bucket_name = google_storage_bucket.story-ai-app.name
  enable_cdn  = false
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CUSTOM SERVICE ACCOUNT FOR UPLOADING THE CONTENTS (THIS IS GIVEN TO GITHUB ACTIONS)
# ---------------------------------------------------------------------------------------------------------------------

module "gke_service_account" {
  source  = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account"
  project = "storyscript"

  name                  = "story-ai-gh-action-sa"
  description           = "story ai gh action service account"
  service_account_roles = ["roles/storage.objectAdmin"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A KEY FOR THE SERVICE ACCOUNT
# ---------------------------------------------------------------------------------------------------------------------

resource "google_service_account_key" "story-ai-app-gh-actions" {
  service_account_id = module.gke_service_account.email
}

output "service_account_key" {
  description = "Account key to provide to GitHub actions"
  value       = base64decode(google_service_account_key.story-ai-app-gh-actions.private_key)
  sensitive   = true
}

