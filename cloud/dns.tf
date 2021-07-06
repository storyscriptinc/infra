# ---------------------------------------------------------------------------------------------------------------------
# DNS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "account" {
  name = "account.${var.domain}."
  type = "A"
  ttl  = 300

  managed_zone = var.managed_zone
  rrdatas      = [google_compute_global_forwarding_rule.global_https_forwarding_rule.ip_address]
}

resource "google_compute_ssl_certificate" "platform" {
  description = "The cert for the ${terraform.workspace}"

  private_key = var.cert_privkey
  certificate = var.cert_fullchain

  lifecycle {
    create_before_destroy = true
  }
}
