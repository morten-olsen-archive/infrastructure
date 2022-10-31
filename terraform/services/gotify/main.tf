module "proxy" {
  source    = "../proxy"
  port      = 80
  name      = "gotify"
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "main" {
  name = "ghcr.io/gotify/server:latest"
}

resource "docker_image" "main" {
  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
}

resource "docker_volume" "main" {
  name = "${local.namespace}-gotify"
}

resource "docker_container" "main" {
  name    = "${local.namespace}-gotify"
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

  labels {
    label = "traefik.http.services.gotify.loadbalancer.passhostheader"
    value = "true"
  }

  labels {
    label = "traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto"
    value = "http"
  }

  mounts {
    type   = "volume"
    target = "/app/data"
    source = docker_volume.main.name
  }
}
