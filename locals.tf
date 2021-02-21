locals {
  standard_egress_rules = [
    {
      description   = "http_any"
      from_port     = 80
      to_port       = 80
      protocol      = "tcp"
      cidr_blocks   = "0.0.0.0/0"
    },
    {
      description   = "https_any"
      from_port     = 443
      to_port       = 443
      protocol      = "tcp"
      cidr_blocks   = "0.0.0.0/0"
    },
    {
      description   = "icmp_echo-request"
      from_port     = 8
      to_port       = "-1"
      protocol      = "icmp"
      cidr_blocks   = "0.0.0.0/0"
    }
  ]
}
