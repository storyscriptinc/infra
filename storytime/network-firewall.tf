# Basic Network Firewall Rules | network-firewall.tf  

# Allow http
resource "google_compute_firewall" "allow-http" {
  name    = "${var.env_name}-${var.env_subname}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}

# # allow https
resource "google_compute_firewall" "allow-https" {
  name    = "${var.env_name}-${var.env_subname}-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.env_name}-${var.env_subname}-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}

resource "google_compute_firewall" "allow-webhook" {
  name    = "${var.env_name}-${var.env_subname}-fw-allow-webhook"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["9999"]
  }
  target_tags = ["webhook"]
}
