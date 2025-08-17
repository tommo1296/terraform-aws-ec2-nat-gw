data "aws_subnets" "private_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = var.private_subnet_lookup_tags
}

data "aws_subnet" "private_subnets" {
  for_each  = toset(data.aws_subnets.private_subnet_ids.ids)
  id        = each.value
}

data "aws_subnet" "destination_subnet" {
  tags = var.public_subnet_lookup_tags

  filter {
    name    = "tag:Name"
    values  = ["*${var.availability_zone}"]
  }
}

data "aws_route_table" "private_route_tables" {
  for_each    = toset(data.aws_subnets.private_subnet_ids.ids)
  subnet_id   = each.value
}
