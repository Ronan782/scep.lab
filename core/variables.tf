variable "vpc_cidr" {
  type    = string
  default = "10.40.0.0/16"
}

variable "bastion_subnet_cidr" {
  type    = string
  default = "10.40.10.0/24"
}

variable "Ip_cidr" {
  type    = string
  default = "91.170.39.139/32"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "create_gateway" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = { project = "scep-lab", env = "core", owner = "student" }
}
