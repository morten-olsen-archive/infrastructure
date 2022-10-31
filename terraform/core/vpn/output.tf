output "clients" {
  value = module.clients
}

output "network" {
  value = {
    name  = docker_network.vpn_network.name
    range = local.docker.network.range
    mask  = local.docker.network.mask
    ip    = "${local.docker.network.range}.10"
  }
}
