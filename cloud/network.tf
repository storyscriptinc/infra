# Single region, private only network configuration

resource "google_compute_network" "vpc" {
  name                    = "${terraform.workspace}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "private_subnet" {
  provider      = google-beta
  purpose       = "PRIVATE"
  name          = "${terraform.workspace}-private-subnet"
  ip_cidr_range = var.private_subnet_cidr
  network       = google_compute_network.vpc.name
}

resource "google_compute_address" "nat_ip" {
  name = "${terraform.workspace}-nat-ip"
}

# create a nat to allow private instances connect to internet
resource "google_compute_router" "nat_router" {
  name    = "${terraform.workspace}-nat-router"
  network = google_compute_network.vpc.name
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${terraform.workspace}-nat-gateway"
  router                             = google_compute_router.nat_router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat_ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_address.nat_ip]
}