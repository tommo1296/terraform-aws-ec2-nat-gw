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

resource "aws_network_interface" "nat_gateway_eni" {
  subnet_id = data.aws_subnet.destination_subnet.id

  source_dest_check = false

  security_groups = [aws_security_group.nat_gateway_sg.id]

  tags = merge(
    {
      Name = "${var.name}-eni"
    },
    var.tags
  )
}

resource "aws_instance" "nat_gateway" {
  ami             = data.aws_ami.nat_gateway_ami.id
  instance_type   = var.instance_type

  key_name = var.key_name

  network_interface {
    network_interface_id  = aws_network_interface.nat_gateway_eni.id
    device_index          = 0
  }

  root_block_device {
    volume_size = 8
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_route" "nat_gateway_route" {
  for_each = data.aws_route_table.private_route_tables

  route_table_id          = each.value.route_table_id
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_network_interface.nat_gateway_eni.id
}
