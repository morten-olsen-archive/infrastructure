locals {
  namespace = var.namespace
  host = {
    zone      = var.zone
    subdomain = var.subdomain
    ip        = var.host_ip
  }
  wireguard = {
    network = {
      range = var.wireguard_network_range
      mask  = var.wireguard_network_mask
    }
  }
  docker = {
    network = {
      range = var.docker_network_range
      mask  = var.docker_network_mask
    }
  }
}
