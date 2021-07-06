# ---------------------------------------------------------------------------------------------------------------------
# VM with (docker) container metadata
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_instance" "account" {
  name         = "${terraform.workspace}-account"
  machine_type = "f1-micro"
  zone         = var.zone
  hostname     = "${terraform.workspace}-account.${var.domain}"


  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  tags = ["ssh", "http"]

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet.name
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
  }
}

module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image = "docker.io/storyscript/account"
    env = [
      {
        name  = "PORT"
        value = "80"
      },
      {
        name  = "BASE_URL"
        value = "https://account.story.ai"
      },
      {
        name  = "OWNER_DATABASE_URL"
        value = "postgres://${var.db_username}:${var.db_password}@${google_sql_database_instance.platform.first_ip_address}/storyai"
      },
      {
        name  = "VISITOR_DATABASE_URL"
        value = "postgres://${var.graphql_authenticator_username}:${var.graphql_authenticator_password}@${google_sql_database_instance.platform.first_ip_address}/storyai"
      }
    ]
  }

  restart_policy = "Always"
}
