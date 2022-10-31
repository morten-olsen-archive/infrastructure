variable "namespace" {

}

variable "timezone" {
  default = "Europe/Amsterdam"
}

variable "devices" {

}

variable "host" {

}

variable "storage" {
}

variable "cloudflare" {
  sensitive = true
}

variable "zone" {
  type = string
}

variable "internal_subdomain" {
  type     = string
  nullable = true
  default  = null
}

variable "external_subdomain" {
  type     = string
  nullable = true
  default  = null
}

variable "device_subdomain" {
  type     = string
  nullable = true
  default  = null
}
