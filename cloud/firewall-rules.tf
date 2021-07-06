# Basic Network Firewall Rules

# Allow internal icmp
resource "google_compute_firewall" "allow_internal" {
  name    = "${terraform.workspace}-fw-allow-internal"
  network = google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${var.private_subnet_cidr}"
  ]
}

# Allow http
resource "google_compute_firewall" "allow_http" {
  name    = "${terraform.workspace}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}

# allow https
# resource "google_compute_firewall" "allow-https" {
#   name    = "${terraform.workspace}-fw-allow-https"
#   network = google_compute_network.vpc.name
#   allow {
#     protocol = "tcp"
#     ports    = ["443"]
#   }
#   target_tags = ["https"]
# }

# allow ssh
resource "google_compute_firewall" "allow_ssh" {
  name    = "${terraform.workspace}-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}