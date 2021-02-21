data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = var.vpc_id

  tags = var.private_subnet_lookup_tags
}

data "aws_subnet" "private_subnets" {
  for_each  = data.aws_subnet_ids.private_subnet_ids.ids
  id        = each.value
}

data "aws_subnet" "destination_subnet" {
  tags = var.public_subnet_lookup_tags

  filter {
    name    = "tag:Name"
    values  = ["*${var.availability_zone}"]
  }
}

data "aws_ami" "nat_gateway_ami" {
  most_recent   = true
  owners        = ["137112412989"]

  filter {
    name    = "name"
    values  = ["amzn-ami-vpc-nat-*"]
  }
}

data "aws_route_table" "private_route_tables" {
  for_each    = data.aws_subnet_ids.private_subnet_ids.ids
  subnet_id   = each.value
}
