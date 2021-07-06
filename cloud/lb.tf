# Load balancer with unmanaged instance group

resource "google_compute_global_address" "default" {
  name         = "${terraform.workspace}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

# ---------------------------------------------------------------------------------------------------------------------
# Forwarding HTTP(S) traffic
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_global_forwarding_rule" "global_https_forwarding_rule" {
  name       = "${terraform.workspace}-global-https-forwarding-rule"
  target     = google_compute_target_https_proxy.target_https_proxy.self_link
  ip_address = google_compute_global_address.default.address
  port_range = "443"
}

resource "google_compute_target_https_proxy" "target_https_proxy" {
  name             = "${terraform.workspace}-https-proxy"
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_ssl_certificate.platform.id]
}

# ---------------------------------------------------------------------------------------------------------------------
# Instance group and backend services
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_backend_service" "account" {
  name          = "${terraform.workspace}-account-backend-service"
  port_name     = "http"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]

  backend {
    group                 = google_compute_instance_group.account_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_instance_group" "account_group" {
  name        = "${terraform.workspace}-vm-group"
  description = "Account Servers instance group"
  zone        = var.zone

  instances = [
    google_compute_instance.account.self_link
  ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }
}

# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "healthcheck" {
  name               = "${terraform.workspace}-healthcheck"
  timeout_sec        = 1
  check_interval_sec = 1
  tcp_health_check {
    port = 80
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Load Balancing
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_url_map" "url_map" {
  name            = "${terraform.workspace}-load-balancer"
  default_service = google_compute_backend_service.account.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }

  path_matcher {
    name            = "all"
    default_service = google_compute_backend_service.account.self_link
  }
}
