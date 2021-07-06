# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# GCP Project
# ---------------------------------------------------------------------------------------------------------------------

variable "credentials" {
  description = "The GCP JSON Credentials."
  type        = string
}

variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "region" {
  description = "The region."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Database
# ---------------------------------------------------------------------------------------------------------------------

variable "db_username" {
  description = "The name of the master database user."
  type        = string
}

variable "db_password" {
  description = "The password of the master database user."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# GraphQL
# ---------------------------------------------------------------------------------------------------------------------

variable "graphql_authenticator_username" {
  description = "The name of the graphql authenticator."
  type        = string
}

variable "graphql_authenticator_password" {
  description = "The password of the graphql authenticator."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# DNS
# ---------------------------------------------------------------------------------------------------------------------

variable "domain" {
  type        = string
  description = "The domain name."
}

variable "managed_zone" {
  type        = string
  description = "The name of the managed zone."
}

variable "cert_privkey" {
  type        = string
  description = "Path to the certificate private key."
}

variable "cert_fullchain" {
  type        = string
  description = "Path to the certificate full chain."
}

# ---------------------------------------------------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------------------------------------------------

variable "zone" {
  type        = string
  description = "GCP zone"
}

# TODO: can this be defaulted?
variable "private_subnet_cidr" {
  type        = string
  description = "private subnet CIDR 1"
}