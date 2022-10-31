locals {
  port       = var.port
  namespace  = var.namespace
  network    = var.network
  zone_names = distinct([for record in var.records : record.zone])
  zones = [
    for zone in local.zone_names :
    {
      name = zone
      records = toset(
        [for record in var.records : {
          type  = record.type
          name  = record.name
          value = record.value
        } if record.zone == zone]
      )
    }
  ]
}
