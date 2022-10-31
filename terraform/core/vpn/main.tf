resource "wireguard_asymmetric_key" "main" {
}

data "cloudflare_zone" "main" {
  name = local.host.zone
}

resource "cloudflare_record" "main" {
  zone_id = data.cloudflare_zone.main.id
  name    = local.host.subdomain
  value   = local.host.ip
  type    = "A"
  ttl     = 3600
}

resource "docker_image" "main" {
  name = "${local.namespace}-wireguard"
  build {
    path = "${path.module}/docker"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "docker/*") : filesha1("${path.module}/${f}")]))
  }
}

resource "docker_network" "vpn_network" {
  name   = "${local.namespace}-vpn"
  driver = "bridge"
  ipam_config {
    subnet  = "${local.docker.network.range}.0/${local.docker.network.mask}"
    gateway = "${local.docker.network.range}.1"
  }
}

resource "docker_container" "wireguard" {
  name       = "${local.namespace}-wireguard"
  image      = docker_image.main.image_id
  restart    = "unless-stopped"
  privileged = true
  sysctls = {
    "net.ipv4.ip_forward" = "1"
  }

  ports {
    internal = 51820
    external = 51820
    protocol = "udp"
  }

  upload {
    file = "/etc/wireguard/wg0.conf"
    content = templatefile(
      "${path.module}/assets/config.tpl",
      {
        clients       = module.clients
        network_range = local.wireguard.network.range
        network_mask  = local.wireguard.network.mask
        host_key      = "${wireguard_asymmetric_key.main.private_key}"
      }
    )
  }

  capabilities {
    add = ["NET_ADMIN", "SYS_MODULE"]
  }

  networks_advanced {
    name         = docker_network.vpn_network.name
    ipv4_address = "${local.docker.network.range}.10"
  }

  mounts {
    type   = "bind"
    target = "/lib/modules"
    source = "/lib/modules"
  }
}

module "clients" {
  source        = "./client"
  for_each      = var.clients
  namespace     = local.namespace
  id            = each.key
  ip            = each.value.ip
  host_key      = wireguard_asymmetric_key.main.public_key
  network_mask  = local.wireguard.network.mask
  network_range = local.wireguard.network.range
  host_address  = cloudflare_record.main.hostname
  dns           = var.dns
}
