resource "wireguard_asymmetric_key" "main" {
}

resource "local_file" "config" {
  content  = local.config
  filename = "${path.root}/../output/${local.namespace}/${var.id}/wg0.conf"
}
