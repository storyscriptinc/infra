# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CLOUD SQL DATABASE
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_database_instance" "platform" {
  # We append a random suffix because GCP doesn't allow name reuse for a week
  name             = "${terraform.workspace}-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    disk_type = "PD_SSD"

    tier = "db-custom-1-4096"

    backup_configuration {
      enabled = true
    }

    maintenance_window {
      day  = 6
      hour = 0
    }

    # Change this for any production workload
    ip_configuration {
      require_ssl = false
      authorized_networks {
        name  = "everywhere"
        value = "0.0.0.0/0"
      }
      ipv4_enabled = "true"
    }
  }
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database" "platform" {
  name     = "storyai"
  instance = google_sql_database_instance.platform.name
}

resource "google_sql_user" "platform" {
  instance = google_sql_database_instance.platform.name
  name     = var.db_username
  password = var.db_password
}

output "database_ip" {
  description = "The IP address of the database."
  value       = google_sql_database_instance.platform.first_ip_address
}

