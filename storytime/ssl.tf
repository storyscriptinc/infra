# ---------------------------------------------------------------------------------------------------------------------
# SSL
# ---------------------------------------------------------------------------------------------------------------------
resource "google_dns_record_set" "story-pages" {
  // hardcoded runtime here because I went over the limit of certs generated for
  // *.storytime.storyscript-ci.com :fullmoon-with-face:
  name = "${var.env_deploy_name}.runtime.${var.env_domain}."
  type = "A"
  ttl  = 300

  managed_zone = var.env_domain_managed_zone
  rrdatas      = [google_compute_global_forwarding_rule.global_https_forwarding_rule.ip_address]
}

resource "google_compute_ssl_certificate" "storytime" {
  name_prefix = var.env_project
  description = "the cert for the ${var.env_deploy_name}"

  // YOU WILL NEED TO GET THE CERTS ON DISK IF YOU ARE CREATING THIS RESOURCE FROM SCRATCH
  private_key = var.cert_privkey
  certificate = var.cert_fullchain

  lifecycle {
    create_before_destroy = true
  }
}
