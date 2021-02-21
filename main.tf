resource "aws_security_group" "nat_gateway_sg" {
  name          = "${var.name}-sg"
  description   = "Rules for outbound traffic in private subnets"
  vpc_id        = var.vpc_id

  tags = merge(
    {
      Name = "${var.name}-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "private_subnets" {
  for_each = data.aws_subnet.private_subnets

  security_group_id   = aws_security_group.nat_gateway_sg.id
  type                = "ingress"
  description         = "private-subnets_any"
  from_port           = 0
  to_port             = 0
  protocol            = "-1"
  cidr_blocks         = [each.value.cidr_block]
}

resource "aws_security_group_rule" "custom_ingress_rules" {
  count = length(var.custom_ingress_rules)

  security_group_id   = aws_security_group.nat_gateway_sg.id
  type                = "ingress"
  description         = element(var.custom_ingress_rules, count.index).description
  from_port           = element(var.custom_ingress_rules, count.index).from_port
  to_port             = element(var.custom_ingress_rules, count.index).to_port
  protocol            = element(var.custom_ingress_rules, count.index).protocol
  cidr_blocks         = split(",", element(var.custom_ingress_rules, count.index).cidr_blocks)
}

resource "aws_security_group_rule" "standard_egress_rules" {
  count = length(local.standard_egress_rules)

  security_group_id   = aws_security_group.nat_gateway_sg.id
  type                = "egress"
  description         = element(local.standard_egress_rules, count.index).description
  from_port           = element(local.standard_egress_rules, count.index).from_port
  to_port             = element(local.standard_egress_rules, count.index).to_port
  protocol            = element(local.standard_egress_rules, count.index).protocol
  cidr_blocks         = split(",", element(local.standard_egress_rules, count.index).cidr_blocks)
}

resource "aws_security_group_rule" "custom_egress_rules" {
  count = length(var.custom_egress_rules)

  security_group_id   = aws_security_group.nat_gateway_sg.id
  type                = "egress"
  description         = element(var.custom_egress_rules, count.index).description
  from_port           = element(var.custom_egress_rules, count.index).from_port
  to_port             = element(var.custom_egress_rules, count.index).to_port
  protocol            = element(var.custom_egress_rules, count.index).protocol
  cidr_blocks         = split(",", element(var.custom_egress_rules, count.index).cidr_blocks)
}
