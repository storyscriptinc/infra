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
  version     = "~> 3.4.0"
  project     = "storyscript"
  region      = "us-east4"
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE DNS RECORDS
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# STORY-AI PRIMARY
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "story-ai-apex" {
  name = "story.ai."
  type = "A"
  ttl  = 300

  managed_zone = "story-ai"
  rrdatas      = ["75.2.70.75", "99.83.190.102"]
}

resource "google_dns_record_set" "story-ai-www" {
  name = "www.story.ai."
  type = "CNAME"
  ttl  = 300

  managed_zone = "story-ai"
  rrdatas      = ["proxy-ssl.webflow.com."]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT ALIASES (POINT TO WEBFLOW)
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-apex" {
  name = "storyscript.com."
  type = "A"
  ttl  = 300

  managed_zone = "storyscript-com"
  rrdatas      = ["75.2.70.75", "99.83.190.102"]
}

resource "google_dns_record_set" "storyscript-www" {
  name = "www.storyscript.com."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscript-com"
  rrdatas      = ["proxy-ssl.webflow.com."]
}

resource "google_dns_record_set" "storyscri-pt-apex" {
  name = "storyscri.pt."
  type = "A"
  ttl  = 300

  managed_zone = "storyscri-pt"
  rrdatas      = ["75.2.70.75", "99.83.190.102"]
}

resource "google_dns_record_set" "storyscri-pt-www" {
  name = "www.storyscri.pt."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscri-pt"
  rrdatas      = ["proxy-ssl.webflow.com."]
}


resource "google_dns_record_set" "storyscript-io-apex" {
  name = "storyscript.io."
  type = "A"
  ttl  = 300

  managed_zone = "storyscript-io"
  rrdatas      = ["75.2.70.75", "99.83.190.102"]
}

resource "google_dns_record_set" "storyscript-io-www" {
  name = "www.storyscript.io."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscript-io"
  rrdatas      = ["proxy-ssl.webflow.com."]
}

# ---------------------------------------------------------------------------------------------------------------------
# MX Records
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-io-mx" {
  name = "storyscript.io."
  type = "MX"
  ttl  = 3600

  managed_zone = "storyscript-io"
  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com."
  ]
}

resource "google_dns_record_set" "storyscript-com-mx" {
  name = "storyscript.com."
  type = "MX"
  ttl  = 3600

  managed_zone = "storyscript-com"
  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com."
  ]
}
