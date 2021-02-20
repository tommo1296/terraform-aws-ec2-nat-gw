variable "name" {
  description   = "The name to apply to the NAT Gateway"
  type          = string
  default       = "nat-gateway"
}

variable "vpc_id" {
  description   = "ID of the VPC to attach this NAT Gateway to"
  type          = string
}

variable "tags" {
  description   = "Tags to apply to all NAT Gateway resources"
  type          = map(string)
  default       = {}
}
