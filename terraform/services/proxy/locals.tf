locals {
  name      = var.name
  port      = var.port
  proxy     = var.proxy
  subdomain = var.subdomain
  external  = var.external
  domain    = local.external ? "${local.subdomain}.${local.proxy.domains.external}" : "${local.subdomain}.${local.proxy.domains.internal}"
  labels = {
    "traefik.enable"                                 = "true"
    "traefik.http.routers.${local.name}.rule"        = "Host(`${local.domain}`)"
    "traefik.http.routers.${local.name}.tls"         = "{}"
    "traefik.http.routers.${local.name}.entrypoints" = local.external ? local.proxy.entrypoints.external : local.proxy.entrypoints.internal
    "traefik.http.services.${local.name}.loadbalancer.server.port" : local.port
  }
}
