variable "core" {

}

variable "external" {
  default = false
}

variable "subdomain" {
  default = "backup"
}

variable "backup_volumes" {
  default = {}
}
