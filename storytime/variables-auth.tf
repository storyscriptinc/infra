# Google Cloud connection & authentication and Application configuration | variables-auth.tf

# GCP authentication file
variable "gcp_auth_file" {
  type        = string
  description = "GCP authentication file"
}

# define GCP project name
variable "env_project" {
  type        = string
  description = "GCP project name"
}

# define application name (storytime)
variable "env_name" {
  type        = string
  description = "Application name"
  default     = "storytime"
}

# define application domain
variable "env_domain" {
  type        = string
  description = "Application domain"
}

# define application environment (prod, test, main, customer, ...)
variable "env_subname" {
  type        = string
  description = "Application environment"
}
