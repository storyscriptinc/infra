# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "credentials" {
  description = "The GCP JSON Credentials."
  type        = string
}

variable "cert_privkey" {
  type        = string
  description = "Path to the certificate private key."
}

variable "cert_fullchain" {
  type        = string
  description = "Path to the certificate full chain."
}
