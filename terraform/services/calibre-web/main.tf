module "proxy" {
  source    = "../proxy"
  port      = 8083
  name      = "calibre-web"
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "main" {
  name = "ghcr.io/linuxserver/calibre-web:latest"
}

resource "docker_image" "main" {
  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
}

resource "docker_volume" "main" {
  name = "${local.namespace}-calibre-web"
}

resource "docker_container" "main" {
  name    = "${local.namespace}-calibre-web"
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
    read_only = true
    type      = "bind"
    target    = "/books"
    source    = local.storage.books
  }
}
