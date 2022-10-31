module "vpn" {
  source    = "./vpn"
  namespace = local.namespace
  clients   = local.devices
  host_ip   = local.host.ip.external
  zone      = local.zone
  dns       = module.vpn_dns.ip
}

module "vpn_dns" {
  source    = "./dns"
  namespace = local.namespace
  network = {
    name = module.vpn.network.name
    ip   = "${module.vpn.network.range}.2"
  }
  records = concat(
    [
      for id, device in module.vpn.clients :
      {
        zone  = local.zone
        name  = "${id}.${local.device_subdomain}"
        type  = "A"
        value = device.ip
      }
    ],
    [
      {
        zone  = local.zone
        name  = "*.${local.external_subdomain}"
        type  = "A"
        value = module.proxy.vpn.ip
      }
    ],
    [
      {
        zone  = local.zone
        name  = "*.${local.internal_subdomain}"
        type  = "A"
        value = module.internal_access.vpn.ip
      }
    ]
  )
}

module "vpn_network" {
  source    = "./dns"
  namespace = "${local.namespace}-network"
  network = {
    name = module.vpn.network.name
    ip   = "${module.vpn.network.range}.3"
  }
  port = 53
  records = concat(
    [
      {
        zone  = local.zone
        name  = "*.${local.external_subdomain}"
        type  = "A"
        value = local.host.ip.internal
      }
    ],
  )
}

module "proxy" {
  source               = "./proxy"
  namespace            = local.namespace
  zone                 = local.zone
  cloudflare_api_token = local.cloudflare.api_token
  external_subdomain   = local.external_subdomain
  internal_subdomain   = local.internal_subdomain
  host                 = local.host

  vpn = {
    network = module.vpn.network
    ip      = "${module.vpn.network.range}.5"
  }
}

module "internal_access" {
  source    = "./internal-access"
  namespace = local.namespace
  proxy = {
    ip = module.proxy.vpn.ip
  }
  vpn = {
    network = module.vpn.network
    ip      = "${module.vpn.network.range}.6"
  }
}

module "storage" {
  source    = "./storage"
  namespace = local.namespace
  storage   = local.storage
}
