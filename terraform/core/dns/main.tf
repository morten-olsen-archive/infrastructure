resource "docker_image" "main" {
  name = "${local.namespace}-dns"
  build {
    path = "${path.module}/docker"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "docker/*") : filesha1("${path.module}/${f}")]))
  }
}

resource "docker_container" "dns" {
  name    = "${local.namespace}-dns"
  image   = docker_image.main.image_id
  restart = "unless-stopped"

  networks_advanced {
    name         = local.network.name
    ipv4_address = local.network.ip
  }

  dynamic "ports" {
    for_each = local.port == null ? [] : [1]
    content {
      internal = 53
      external = local.port
    }
  }

  upload {
    file = "/etc/bind/named.conf.options"
    content = file(
      "${path.module}/assets/named.conf.options"
    )
  }

  upload {
    file = "/etc/bind/named.conf.local"
    content = templatefile(
      "${path.module}/assets/named.conf.local.tpl",
      {
        zones = local.zones
      }
    )
  }

  dynamic "upload" {
    for_each = local.zones
    content {
      file = "/etc/bind/zones/db.${upload.value.name}"
      content = templatefile(
        "${path.module}/assets/db.tpl",
        {
          zone    = upload.value.name
          dns_ip  = local.network.ip
          records = upload.value.records

        }
      )
    }
  }
}
