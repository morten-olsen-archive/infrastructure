variable "admin_email" {
  type    = string
  default = "morten@olsen.pro"
}

variable "zone" {
  type = string
}

variable "host" {}

variable "external_subdomain" {
  type = string
}

variable "internal_subdomain" {
  type = string
}

variable "namespace" {
  type    = string
  default = "main"
}

variable "vpn" {
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}
