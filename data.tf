data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = var.vpc_id

  tags = var.private_subnet_lookup_tags
}

data "aws_subnet" "private_subnets" {
  for_each  = data.aws_subnet_ids.private_subnet_ids.ids
  id        = each.value
}
