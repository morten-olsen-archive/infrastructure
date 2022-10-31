locals {
  name      = "gonic"
  image     = "sentriz/gonic"
  namespace = var.core.namespace
  proxy     = var.core.proxy
  storage   = var.core.storage
  subdomain = var.subdomain != null ? var.subdomain : local.name
  external  = var.external
  timezone  = var.core.timezone
}
