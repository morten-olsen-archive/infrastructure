locals {
  namespace = var.core.namespace
  proxy     = var.core.proxy
  storage   = var.core.storage
  subdomain = var.subdomain
  external  = var.external
  timezone  = var.core.timezone
  to_backup = var.backup_volumes
  backup_volumes = flatten(toset([
    for app_name, volumes in local.to_backup :
    toset([
      for volume_name, volume in volumes :
      {
        app_name    = app_name
        volume_name = volume_name
        volume      = volume
      }
    ])
  ]))
}
