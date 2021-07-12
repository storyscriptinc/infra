# Load balancer with unmanaged instance group | lb-unmanaged.tf

# ---------------------------------------------------------------------------------------------------------------------
# Forwarding HTTP(S) traffic
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_global_forwarding_rule" "global_http_forwarding_rule" {
  name       = "${var.env_name}-${var.env_deploy_name}-global-http-forwarding-rule"
  project    = var.env_project
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}

resource "google_compute_global_forwarding_rule" "global_https_forwarding_rule" {
  name       = "${var.env_name}-${var.env_deploy_name}-global-https-forwarding-rule"
  project    = var.env_project
  target     = google_compute_target_https_proxy.target_https_proxy.self_link
  port_range = "443"
}

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "${var.env_name}-${var.env_deploy_name}-http-proxy"
  project = var.env_project
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_target_https_proxy" "target_https_proxy" {
  name             = "${var.env_name}-${var.env_deploy_name}-https-proxy"
  project          = var.env_project
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_ssl_certificate.storytime.id]
}

# ---------------------------------------------------------------------------------------------------------------------
# Instance group and backend services
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_backend_service" "backend_service" {
  name          = "${var.env_name}-${var.env_deploy_name}-backend-service"
  project       = var.env_project
  port_name     = "http"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]

  backend {
    group                 = google_compute_instance_group.web_private_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_backend_service" "backend_wh_service" {
  name          = "${var.env_name}-${var.env_deploy_name}-wh-backend-service"
  project       = var.env_project
  port_name     = "webhook"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]

  backend {
    group                 = google_compute_instance_group.web_private_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_instance_group" "web_private_group" {
  name        = "${var.env_name}-${var.env_deploy_name}-vm-group"
  description = "Web servers instance group"
  zone        = var.gcp_zone_1

  instances = [
    google_compute_instance.web_private_1.self_link
  ]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "webhook"
    port = "9999"
  }

  named_port {
    name = "https"
    port = "443"
  }
}

# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "healthcheck" {
  name               = "${var.env_name}-${var.env_deploy_name}-healthcheck"
  timeout_sec        = 1
  check_interval_sec = 1
  tcp_health_check {
    port = 80
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Load balancing
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_url_map" "url_map" {
  name            = "${var.env_name}-${var.env_deploy_name}-load-balancer"
  project         = var.env_project
  default_service = google_compute_backend_service.backend_service.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "storytime"
  }

  path_matcher {
    name            = "storytime"
    default_service = google_compute_backend_service.backend_service.id

    path_rule {
      paths   = ["/webhook", "/webhook/*"]
      service = google_compute_backend_service.backend_wh_service.id
    }
    path_rule {
      paths   = ["/graphql", "/graphql/*"]
      service = google_compute_backend_service.backend_service.id
    }
  }
}
