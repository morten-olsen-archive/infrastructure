output "domain" {
  value = module.proxy.domain
}

output "volumes" {
  value = [
    docker_volume.main
  ]
}
