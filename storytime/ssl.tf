# ---------------------------------------------------------------------------------------------------------------------
# SSL
# ---------------------------------------------------------------------------------------------------------------------
resource "google_dns_record_set" "story-pages" {
  // hardcoded runtime here because I went over the limit of certs generated for
  // *.storytime.storyscript-ci.com :fullmoon-with-face:
  name = "${var.app_environment}.runtime.${var.app_domain}."
  type = "A"
  ttl  = 300

  managed_zone = var.app_domain
  rrdatas      = [google_compute_global_forwarding_rule.global_https_forwarding_rule.ip_address]
}

resource "google_compute_ssl_certificate" "storytime" {
  name_prefix = var.app_project
  description = "the cert for the ${var.app_environment}"

  // YOU WILL NEED TO GET THE CERTS ON DISK IF YOU ARE CREATING THIS RESOURCE FROM SCRATCH
  private_key = file("/path/to/privkey.pem")
  certificate = file("/path/to/fullchain.pem")

  lifecycle {
    create_before_destroy = true
  }
}
