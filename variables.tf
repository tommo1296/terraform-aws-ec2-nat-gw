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

variable "public_subnet_lookup_tags" {
  description   = "A map of tags used to search for public subnets to allow"
  type          = map(string)

  default = {
    Type = "Public"
  }
}

variable "availability_zone" {
  description   = "The availability zone to spin the EC2 NAT Gatway up in"
  type          = string
  default       = "a"
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

variable "instance_type" {
  description   = "Instance type of the EC2 NAT Gateway.  Defaults to cheapest per month"
  type          = string
  default       = "t3a.nano"
}

variable "key_name" {
  description   = "Key for EC2 NAT Gateway if SSH access is required"
  type          = string
  default       = ""
}

variable "enable_public_ip" {
  description   = "Whether to enable a public IP for the NAT Gateway"
  type          = bool
  default       = true
}
