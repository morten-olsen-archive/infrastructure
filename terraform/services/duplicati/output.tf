output "domain" {
  value = module.proxy.domain
}

output "entrypoints" {
  value = [{
    name = locals.name
    url  = entrymodule.proxy.domain
  }]
}

output "volumes" {
  value = [
    docker_volume.main
  ]
}
