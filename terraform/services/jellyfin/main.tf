module "proxy" {
  source    = "../proxy"
  port      = 8096
  name      = "jellyfin"
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "jellyfin" {
  name = "ghcr.io/linuxserver/jellyfin"
}

resource "docker_image" "jellyfin" {
  name          = data.docker_registry_image.jellyfin.name
  pull_triggers = [data.docker_registry_image.jellyfin.sha256_digest]
}

resource "docker_volume" "jellyfin" {
  name = "${local.namespace}-jellyfin"
}

resource "docker_container" "jellyfin" {
  name    = "${local.namespace}-jellyfin"
  image   = docker_image.jellyfin.image_id
  restart = "unless-stopped"

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
    source = docker_volume.jellyfin.name
  }

  mounts {
    read_only = true
    type      = "bind"
    target    = "/media/movies"
    source    = local.storage.movies
  }

  mounts {
    read_only = true
    type      = "bind"
    target    = "/media/tv-shows"
    source    = local.storage.tvshows
  }

  mounts {
    read_only = true
    type      = "bind"
    target    = "/media/music"
    source    = local.storage.music
  }
}
