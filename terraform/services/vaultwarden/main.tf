module "proxy" {
  source    = "../proxy"
  port      = 80
  name      = "vaultwarden"
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "main" {
  name = "vaultwarden/server:latest"
}

resource "docker_image" "main" {
  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
}

resource "docker_volume" "main" {
  name = "${local.namespace}-vaultwarden"
}

resource "docker_container" "main" {
  name    = "${local.namespace}-vaultwarden"
  image   = docker_image.main.image_id
  restart = "unless-stopped"
  env = [
    "DOMAIN=${module.proxy.domain}"
  ]

  networks_advanced {
    name = module.proxy.network
  }

  dynamic "labels" {
    for_each = module.proxy.labels
    content {
      label = labels.key
      value = labels.value
    }
  }

  mounts {
    type   = "volume"
    target = "/data"
    source = docker_volume.main.name
  }
}
