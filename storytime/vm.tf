# ---------------------------------------------------------------------------------------------------------------------
# VM with (docker) container metadata
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_instance" "web_private_1" {
  name         = "${var.env_name}-${terraform.workspace}-vm1"
  machine_type = "f1-micro"
  zone         = var.gcp_zone_1
  hostname     = "${var.env_name}-${terraform.workspace}-vm1.${var.env_domain}"


  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  tags = ["ssh", "http", "https", "webhook"]

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet_1.name
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
  }
}

module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image = "docker.io/storyscript/storytime"
    env = [
      {
        name  = "GCP_SECRETS_SA"
        value = base64decode(google_service_account_key.platform.private_key)
      },
      {
        name = "EXTERNAL_ADDRESS"
        // hardcoded runtime here because I went over the limit of certs generated for
        // *.storytime.storyscript-ci.com :fullmoon-with-face:
        value = "${terraform.workspace}.runtime.${var.env_domain}"
      },
      {
        name  = "PORT"
        value = "80"
      }
    ]
  }

  restart_policy = "Always"
}
