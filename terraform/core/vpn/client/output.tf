output "public_key" {
  value = wireguard_asymmetric_key.main.public_key
}

output "private_key" {
  value     = wireguard_asymmetric_key.main.private_key
  sensitive = true
}

output "config" {
  sensitive = true
  value     = local.config
}

output "ip" {
  value = "${var.network_range}.${var.ip}"
}
