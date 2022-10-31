module "proxy" {
  source    = "../proxy"
  port      = 5232
  name      = "radicale"
  subdomain = local.subdomain
  external  = local.external
  proxy     = local.proxy
}

data "docker_registry_image" "main" {
  name = "tomsquest/docker-radicale:latest"
}

resource "docker_image" "main" {
  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
}

resource "docker_volume" "main" {
  name = "${local.namespace}-radicale"
}

resource "docker_container" "main" {
  name      = "${local.namespace}-radicale"
  image     = docker_image.main.image_id
  restart   = "unless-stopped"
  init      = true
  read_only = true
  env = [
    "TAKE_FILE_OWNERSHIP=false"
  ]
  security_opts = [
    "no-new-privileges:true"
  ]
  capabilities {
    drop = ["all"]
    add = [
      "CHOWN",
      "SETUID",
      "SETGID",
      "KILL"
    ]
  }

  healthcheck {
    test     = ["curl", "--fail", "http://localhost:5232", "||", "exit", "1"]
    interval = "30s"
    retries  = 3
  }

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
