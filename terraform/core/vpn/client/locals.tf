locals {
  namespace = var.namespace
  config = templatefile(
    "${path.module}/assets/config.tpl",
    {
      ip              = var.ip
      dns             = var.dns
      host_address    = var.host_address
      network_mask    = var.network_mask
      network_range   = var.network_range
      private_key     = wireguard_asymmetric_key.main.private_key
      host_public_key = "${var.host_key}"
    }
  )
}
