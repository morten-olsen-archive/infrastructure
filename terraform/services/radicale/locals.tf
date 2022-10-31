locals {
  name      = "radicale"
  namespace = var.core.namespace
  proxy     = var.core.proxy
  storage   = var.core.storage
  subdomain = var.subdomain
  external  = var.external
  timezone  = var.core.timezone
}
