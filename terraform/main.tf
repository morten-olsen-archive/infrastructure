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
  smtp   = local.smtp
}

module "radicale" {
  source = "./services/radicale"
  core   = module.core
}

module "gotify" {
  source = "./services/gotify"
  core   = module.core
}

module "wallabag" {
  source = "./services/wallabag"
  core   = module.core
}

module "freshrss" {
  source = "./services/freshrss"
  core   = module.core
}

module "gonic" {
  source = "./services/gonic"
  core   = module.core
}

module "duplicati" {
  source = "./services/duplicati"
  core   = module.core
  backup_volumes = {
    jellyfin    = module.jellyfin.volumes,
    calibre     = module.calibre_web.volumes,
    vaultwarden = module.vaultwarden.volumes
    radicale    = module.radicale.volumes
    gotify      = module.gotify.volumes
    wallabag    = module.wallabag.volumes
    freshrss    = module.freshrss.volumes
    gonic       = module.gonic.volumes
  }
}
