locals {
  environment = terraform.workspace
  config_path = "${path.root}/../envs/${local.environment}"
  configs = {
    devices = yamldecode(file("${local.config_path}/devices.yml"))
    general = yamldecode(file("${local.config_path}/general.yml"))
    secrets = yamldecode(file("${local.config_path}/secrets.yml"))
  }

  devices            = local.configs.devices
  storage            = local.configs.general.storage
  zone               = local.configs.general.zone
  external_subdomain = try(local.configs.general.subdomain.external, local.namespace)
  internal_subdomain = try(local.configs.general.subdomain.internal, "i.${local.external_subdomain}")
  namespace          = local.environment
  host = {
    ip = {
      external = local.configs.general.host.ip.external
      internal = local.configs.general.host.ip.internal
    }
  }
  docker = try(local.configs.general.docker, "unix:///var/run/docker.sock")
  cloudflare = {
    api_token = local.configs.secrets.cloudflare.api-token
  }

}
