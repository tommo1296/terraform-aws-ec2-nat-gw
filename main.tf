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
