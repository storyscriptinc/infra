terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.7"
  backend "gcs" {
    bucket = "storyscript-infra"
    prefix = "landing/state"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "google" {
  credentials = var.credentials
  version     = "~> 2.9.0"
  project     = "storyscript"
  region      = "us-east4"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE DNS RECORDS
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-COM (APEX/WWW TO WEBFLOW, * TO K8S)
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-apex" {
  name = "storyscript.com."
  type = "A"
  ttl  = 300

  managed_zone = "storyscript-com"
  rrdatas      = ["13.248.155.104", "76.223.27.102"]
}

resource "google_dns_record_set" "storyscript-www" {
  name = "www.storyscript.com."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscript-com"
  rrdatas      = ["proxy-ssl.webflow.com."]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT ALIASES (POINT TO WEBFLOW)
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscri-pt-apex" {
  name = "storyscri.pt."
  type = "A"
  ttl  = 300

  managed_zone = "storyscri-pt"
  rrdatas      = ["13.248.155.104", "76.223.27.102"]
}

resource "google_dns_record_set" "storyscri-pt-www" {
  name = "www.storyscri.pt."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscri-pt"
  rrdatas      = ["proxy-ssl.webflow.com."]
}

resource "google_dns_record_set" "story-ai-apex" {
  name = "story.ai."
  type = "A"
  ttl  = 300

  managed_zone = "story-ai"
  rrdatas      = ["13.248.155.104", "76.223.27.102"]
}

resource "google_dns_record_set" "story-ai-www" {
  name = "www.story.ai."
  type = "CNAME"
  ttl  = 300

  managed_zone = "story-ai"
  rrdatas      = ["proxy-ssl.webflow.com."]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-IO
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-io-apex" {
  name = "storyscript.io."
  type = "A"
  ttl  = 300

  managed_zone = "storyscript-primary"
  rrdatas      = ["13.248.155.104", "76.223.27.102"]
}

resource "google_dns_record_set" "storyscript-io-www" {
  name = "www.storyscript.io."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscript-primary"
  rrdatas      = ["proxy-ssl.webflow.com."]
}
