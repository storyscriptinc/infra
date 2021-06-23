# Single region, private only network configuration | network.tf

# create VPC
resource "google_compute_network" "vpc" {
  name                    = "${terraform.workspace}-creds-refresher-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

# # create private subnet
resource "google_compute_subnetwork" "private_subnet_1" {
  provider      = google-beta
  purpose       = "PRIVATE"
  name          = "${terraform.workspace}-private-subnet-1"
  ip_cidr_range = var.private_subnet_cidr_1
  network       = google_compute_network.vpc.name
  region        = var.gcp_region_1
}

# create a public ip for nat service
resource "google_compute_address" "nat_ip" {
  name    = "${terraform.workspace}-creds-refresher-nat-ip"
  project = var.env_project
  region  = var.gcp_region_1
}

# create a nat to allow private instances connect to internet
resource "google_compute_router" "nat-router" {
  name    = "${terraform.workspace}-creds-refresher-nat-router"
  network = google_compute_network.vpc.name
}

resource "google_compute_router_nat" "nat-gateway" {
  name                               = "${terraform.workspace}-creds-refresher-nat-gateway"
  router                             = google_compute_router.nat-router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat_ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_address.nat_ip]
}

# allow internal icmp
resource "google_compute_firewall" "allow-internal" {
  name    = "${terraform.workspace}-creds-refresher-fw-allow-internal"
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
    "${var.private_subnet_cidr_1}"
  ]
}
