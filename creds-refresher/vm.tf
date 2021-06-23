# ---------------------------------------------------------------------------------------------------------------------
# VM with (docker) container metadata
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_instance" "vm" {
  name         = "${terraform.workspace}-creds-refresher-vm"
  machine_type = "f1-micro"
  zone         = var.gcp_zone_1
  hostname     = "${terraform.workspace}-creds-refresher.story.ai"


  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  tags = ["ssh"]

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
    image = "docker.io/storyscript/creds-refresher"
    env = [
      {
        name  = "GCP_SECRETS_SA_KEY"
        value = base64decode(google_service_account_key.platform.private_key)
      }
    ]
  }

  restart_policy = "Always"
}
