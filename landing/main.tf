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

resource "google_dns_record_set" "storyscri-pt-apex" {
  name = "storyscri.pt."
  type = "A"
  ttl  = 300

  managed_zone = "storyscri-pt"
  rrdatas      = ["104.198.14.52"]
}

resource "google_dns_record_set" "storyscri-pt-www" {
  name = "www.storyscri.pt."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscri-pt"
  rrdatas      = ["storyscri.pt."]
}

resource "google_dns_record_set" "storyscript-apex" {
  name = "storyscript.com."
  type = "A"
  ttl  = 300

  managed_zone = "storyscript-com"
  rrdatas      = ["104.198.14.52"]
}

resource "google_dns_record_set" "storyscript-www" {
  name = "www.storyscript.com."
  type = "CNAME"
  ttl  = 300

  managed_zone = "storyscript-com"
  rrdatas      = ["storyscript.com."]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-IO | MANAGED ZONE
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_managed_zone" "storyscript-io" {
  name     = "storyscript-io"
  dns_name = "storyscript.io."
  project  = "storyscript"
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-IO | A
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-io-www" {
  name = "www.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["104.198.14.52"]
}

resource "google_dns_record_set" "storyscript-io-apex" {
  name = google_dns_managed_zone.storyscript-io.dns_name
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["35.245.52.107"]
}

resource "google_dns_record_set" "storyscript-io-logs" {
  name = "logs.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-metabase" {
  name = "metabase.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-openapiwatcher" {
  name = "openapiwatcher.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-prometheus" {
  name = "prometheus.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-sync" {
  name = "sync.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-api" {
  name = "api.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-api-dashboard" {
  name = "api-dashboard.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-deploy" {
  name = "deploy.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["35.245.52.107"]
}

resource "google_dns_record_set" "storyscript-io-grafana" {
  name = "grafana.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

resource "google_dns_record_set" "storyscript-io-api-hub" {
  name = "api.hub.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.labels.cluster_k8s_ip]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-IO | CNAME
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-io-freshdesk" {
  name = "fd._domainkey.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["fdacc914579.domainkey.freshdesk.com."]
}

resource "google_dns_record_set" "storyscript-io-freshdesk2" {
  name = "fd2._domainkey.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["fd2acc914579.domainkey.freshdesk.com."]
}

resource "google_dns_record_set" "storyscript-io-freshdeskm" {
  name = "fdm._domainkey.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["acc914579.domainkey.freshdesk.com."]
}

resource "google_dns_record_set" "storyscript-io-freshdesk-fddkim" {
  name = "fddkim.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["spfmx.domainkey.freshdesk.com."]
}

resource "google_dns_record_set" "storyscript-io-discourse" {
  name = "discuss.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["storyscript.hosted-by-discourse.com."]
}

resource "google_dns_record_set" "storyscript-io-mailgun" {
  name = "email.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["mailgun.org."]
}

resource "google_dns_record_set" "storyscript-io-sls" {
  name = "sls.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = [google_dns_managed_zone.storyscript-io.dns_name]
}

resource "google_dns_record_set" "storyscript-io-status" {
  name = "status.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["rvz6cbw6zrnh.stspg-customer.com."]
}

resource "google_dns_record_set" "storyscript-io-components" {
  name = "components.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["storybook-asyncy.netlify.com."]
}

resource "google_dns_record_set" "storyscript-io-dashboard" {
  name = "dashboard.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["storyscript-dashboard.netlify.com."]
}

resource "google_dns_record_set" "storyscript-io-dev-dashboard" {
  name = "dev.dashboard.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["dev--storyscript-dashboard.netlify.com."]
}

resource "google_dns_record_set" "storyscript-io-hub" {
  name = "hub.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["hub-asyncy-com.netlify.com."]
}

resource "google_dns_record_set" "storyscript-io-login" {
  name = "login.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["login-asyncy.netlify.com."]
}

resource "google_dns_record_set" "storyscript-io-docs" {
  name = "docs.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["docs-asyncy-com.netlify.com."]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-IO | MX
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-io-mx" {
  name = google_dns_managed_zone.storyscript-io.dns_name
  type = "MX"
  ttl  = 3600

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com."
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-IO | NS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-io-ns" {
  name = google_dns_managed_zone.storyscript-io.dns_name
  type = "NS"
  ttl  = 21600

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas = [
    "ns-cloud-a2.googledomains.com.",
    "ns-cloud-a1.googledomains.com.",
    "ns-cloud-a3.googledomains.com.",
    "ns-cloud-a4.googledomains.com."
  ]
}

resource "google_dns_record_set" "storyscript-io-studio" {
  name = "studio.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "NS"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas = [
    "dns1.p06.nsone.net.",
    "dns2.p06.nsone.net.",
    "dns3.p06.nsone.net.",
    "dns4.p06.nsone.net."
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# STORYSCRIPT-IO | SOA - TXT
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "storyscript-io-soa" {
  name = google_dns_managed_zone.storyscript-io.dns_name
  type = "SOA"
  ttl  = 21600

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["ns-cloud-a1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300"]
}

resource "google_dns_record_set" "storyscript-io-txt" {
  name = google_dns_managed_zone.storyscript-io.dns_name
  type = "TXT"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas = [
    "google-site-verification=ItiTcYX7BAxzp92bSh-5rbR5v_dzBeF4bwRDGVzlfC0",
    "\"v=spf1 include:mailgun.org ~all\""
  ]
}

resource "google_dns_record_set" "storyscript-io-freshdesk-k1" {
  name = "k1._domainkey.${google_dns_managed_zone.storyscript-io.dns_name}"
  type = "TXT"
  ttl  = 300

  managed_zone = google_dns_managed_zone.storyscript-io.name
  rrdatas      = ["\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDD+mQUiQNZGU0IHBOlQIDpEMnIpx7iAs+bpMz6x9AVdIE3CGYaeRv8uNcwKegMqdjZk7vvilKdMrtjz86GPpLg+7h24kgAjQVdnE+ZRaWO7ZPGoc08nIqOUZBalPYfsYEpnAaWpd2Y0o8xwqVR0LDBqDiQL0mYnGBexSec5rOcdwIDAQAB\""]
}
