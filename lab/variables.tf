variable "lab_name"{ 
  type = string 
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_type" {
  type    = string
  default = "web"
}

variable "distribution" {
  type    = string
  default = "amazonlinux2"
} 

variable "taille" {
  type    = string
  default = "small"
}      

variable "lab_subnet_cidr" {
  type    = string
  default = "10.40.20.0/24"
}

variable "vpc_id"{ 
  type = string 
}

variable "bastion_sg_id"{ 
  type = string 
}

variable "key_name" {
  type    = string
  default = "scep-lab-key"
}

variable "tags" {
  type = map(string)
  default = { project="scep-lab", env="lab", owner="student" }
}
