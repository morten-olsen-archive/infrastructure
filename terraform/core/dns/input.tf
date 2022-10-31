variable "port" {
  type     = number
  default  = null
  nullable = true
}

variable "namespace" {
  default = "main"
}

variable "network" {

}

variable "records" {
  default = []
}
