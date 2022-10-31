data "docker_registry_image" "haproxy" {
  name = "haproxy:latest"
}

resource "docker_image" "haproxy" {
  name          = data.docker_registry_image.haproxy.name
  pull_triggers = [data.docker_registry_image.haproxy.sha256_digest]
}

resource "docker_container" "haproxy" {
  name    = "${local.namespace}-internal-access"
  image   = docker_image.haproxy.image_id
  restart = "unless-stopped"

  upload {
    file = "/usr/local/etc/haproxy/haproxy.cfg"
    content = templatefile(
      "${path.module}/assets/config.tpl",
      {
        proxy = {
          ip = local.proxy.ip
        }
      }
    )
  }

  networks_advanced {
    name         = local.vpn.network.name
    ipv4_address = local.vpn.ip
  }
}
