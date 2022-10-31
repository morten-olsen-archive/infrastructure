locals {
  zone               = var.zone
  admin_email        = var.admin_email
  namespace          = var.namespace
  external_subdomain = var.external_subdomain
  internal_subdomain = var.internal_subdomain
  external_domain    = "${var.external_subdomain}.${var.zone}"
  internal_domain    = "${var.internal_subdomain}.${var.zone}"
  cloudflare = {
    api_token = var.cloudflare_api_token
  }
  host          = var.host
  vpn           = var.vpn
  proxy_network = docker_network.proxy_network.name
  shared_labels = {
    "traefik.enable"                   = "true"
    "traefik.http.routers.traefik.tls" = "{}"
  }
  external_labels = merge(local.shared_labels, {
    "traefik.http.routers.traefik.entrypoints" = "external"
  })
  internal_labels = merge(local.shared_labels, {
    "traefik.http.routers.traefik.entrypoints" = "internal"
  })
}
