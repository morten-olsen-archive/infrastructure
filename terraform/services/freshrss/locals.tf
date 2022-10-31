locals {
  name      = "freshrss"
  image     = "freshrss/freshrss"
  namespace = var.core.namespace
  proxy     = var.core.proxy
  storage   = var.core.storage
  subdomain = var.subdomain != null ? var.subdomain : local.name
  external  = var.external
  timezone  = var.core.timezone
}
