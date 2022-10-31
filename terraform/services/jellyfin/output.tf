output "domain" {
  value = module.proxy.domain
}

output "volumes" {
  value = {
    main = docker_volume.jellyfin
  }
}
