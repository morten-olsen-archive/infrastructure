locals {
  namespace          = var.namespace
  zone               = var.zone
  timezone           = var.timezone
  external_subdomain = var.external_subdomain != null ? var.external_subdomain : local.namespace
  internal_subdomain = var.internal_subdomain != null ? var.internal_subdomain : "i.${local.external_subdomain}"
  external_domain    = "${local.external_subdomain}.${local.zone}"
  internal_domain    = "${local.internal_subdomain}.${local.zone}"
  device_subdomain   = var.device_subdomain != null ? var.device_subdomain : "d.${local.internal_subdomain}"
  host               = var.host
  devices            = var.devices
  storage            = var.storage
  cloudflare         = var.cloudflare
}
