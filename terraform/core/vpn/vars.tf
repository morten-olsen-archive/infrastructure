variable "namespace" {
  type    = string
  default = "main"
}

variable "zone" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "subdomain" {
  type    = string
  default = "vpn"
}

variable "host_address" {
  type    = string
  default = "foo"
}

variable "clients" {

}

variable "docker_network_range" {
  type    = string
  default = "172.50.3"
}

variable "docker_network_mask" {
  type    = string
  default = "24"
}

variable "wireguard_network_range" {
  default = "172.50.4"
}

variable "wireguard_network_mask" {
  type    = string
  default = "24"
}

variable "dns" {
  type = string
}
