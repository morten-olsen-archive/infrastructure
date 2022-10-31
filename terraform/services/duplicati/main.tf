module "proxy" {
  source    = "../proxy"
  port      = 8200
  name      = "duplicati"
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "main" {
  name = "ghcr.io/linuxserver/duplicati:latest"
}

resource "docker_image" "main" {
  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
}

resource "docker_volume" "main" {
  name = "${local.namespace}-duplicati"
}

resource "docker_container" "main" {
  name    = "${local.namespace}-duplicati"
  image   = docker_image.main.image_id
  restart = "unless-stopped"
  env = [
    "TZ=${local.timezone}"
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
    target = "/config"
    source = docker_volume.main.name
  }

  mounts {
    type      = "bind"
    read_only = true
    target    = "/source/media"
    source    = local.storage.media
  }

  dynamic "mounts" {
    for_each = local.backup_volumes
    content {
      read_only = true
      type      = "volume"
      target    = "/source/configs/${mounts.value.app_name}/${mounts.value.volume_name}"
      source    = mounts.value.volume.name
    }
  }
}
