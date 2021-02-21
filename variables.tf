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

variable "private_subnet_lookup_tags" {
  description   = "A map of tags used to search for private subnets to allow"
  type          = map(string)

  default = {
    Type = "Private"
  }
}

variable "custom_ingress_rules" {
  description   = "Map of additional ingress rules for the SG"
  type          = list(map(string))
  default       = []
}

variable "custom_egress_rules" {
  description   = "Map of additional egress rules for the SG"
  type          = list(map(string))
  default       = []
}
