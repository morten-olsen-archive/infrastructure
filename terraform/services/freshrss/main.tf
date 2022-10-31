module "proxy" {
  source    = "../proxy"
  port      = 80
  name      = local.name
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "main" {
  name = "${local.image}:latest"
}

resource "docker_image" "main" {
  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
}

resource "docker_volume" "main" {
  name = "${local.namespace}-${local.name}"
}

resource "docker_volume" "extensions" {
  name = "${local.namespace}-${local.name}-extensions"
}

resource "docker_container" "main" {
  name    = "${local.namespace}-${local.name}"
  image   = docker_image.main.image_id
  restart = "unless-stopped"
  env = [
    "TZ=${local.timezone}",
    "CRON_MIN=4,34"
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
    target = "/var/www/FreshRSS/data"
    source = docker_volume.main.name
  }

  mounts {
    type   = "volume"
    target = "/var/www/FreshRSS/extensions"
    source = docker_volume.extensions.name
  }
}
