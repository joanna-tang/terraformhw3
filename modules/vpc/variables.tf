variable "prefix" {
  type = string
  default = "jtang-hw3"
}

variable "ipblock" {
  type = string
  default = "172.101.0.0/16"  #use cidrsubnet(prefix, newbits, netnum)
}
