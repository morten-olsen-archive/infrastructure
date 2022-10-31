module "core" {
  source             = "./core"
  namespace          = local.namespace
  host               = local.host
  cloudflare         = local.cloudflare
  devices            = local.devices
  zone               = local.zone
  external_subdomain = local.external_subdomain
  internal_subdomain = local.internal_subdomain
  storage            = local.storage
}

module "jellyfin" {
  source = "./services/jellyfin"
  core   = module.core
}

module "calibre_web" {
  source = "./services/calibre-web"
  core   = module.core
}

module "vaultwarden" {
  source = "./services/vaultwarden"
  core   = module.core
}

module "duplicati" {
  source = "./services/duplicati"
  core   = module.core
  backup_volumes = {
    jellyfin    = module.jellyfin.volumes,
    calibre     = module.calibre_web.volumes,
    vaultwarden = module.vaultwarden.volumes
  }
}
