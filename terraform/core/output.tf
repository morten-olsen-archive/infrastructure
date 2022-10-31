output "vpn" {
  value = module.vpn
}

output "proxy" {
  value = module.proxy
}

output "storage" {
  value = module.storage
}

output "namespace" {
  value = local.namespace
}

output "timezone" {
  value = local.timezone
}

output "dns" {
  value = {
    vpn = module.vpn_dns.ip
  }
}
