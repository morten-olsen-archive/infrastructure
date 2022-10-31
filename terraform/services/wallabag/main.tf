module "proxy" {
  source    = "../proxy"
  port      = 80
  name      = local.name
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "main" {
  name = "wallabag/wallabag:latest"
}

resource "docker_image" "main" {
  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
}

resource "docker_volume" "main" {
  name = "${local.namespace}-${local.name}"
}

resource "docker_volume" "images" {
  name = "${local.namespace}-${local.name}-images"
}

resource "docker_container" "main" {
  name    = "${local.namespace}-${local.name}"
  image   = docker_image.main.image_id
  restart = "unless-stopped"
  env = [
    "TZ=${local.timezone}",
    "SYMFONY__ENV__DOMAIN_NAME=https://${module.proxy.domain}",
    "SYMFONY__ENV__SERVER_NAME=Wallabag",
    "SYMFONY__ENV__FOSUSER_CONFIRMATION=false",
    "SYMFONY__ENV__FOSUSER_REGISTRATION=false"
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
    target = "/var/www/wallabag"
    source = docker_volume.main.name
  }

  mounts {
    type   = "volume"
    target = "/var/www/wallabag/web/assets/images"
    source = docker_volume.images.name
  }
}
