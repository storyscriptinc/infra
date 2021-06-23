# # Basic Network Firewall Rules | network-firewall.tf  

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "${terraform.workspace}-creds-refresher-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}
