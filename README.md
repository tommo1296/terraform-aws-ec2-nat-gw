# terraform-aws-ec2-nat-gw

Because NAT Gateways are quite expensive when you just want something to give your private subnets a route out to the internet, the EC2 NAT Gateway is a cheaper option.  It defaults to starting a single `t3a.nano` instance, which is roughly $3 per month.

Currently, this module only supports a single EC2 NAT Gateway instance in a Subnet / AZ of your choosing.  This defaults to `a` az depending on which region you have chosen.  You can be more specific of region and az if you want.

The resources this module creates / modifies are:

 - Security Groups
 - Security Group Rules
 - Network interface
 - EC2 Instance
 - Route table

## Breaking change

In `v0.3.0`, this module removed support for AMI looking and requires that you provide `ami_id` yourself.  This AMI ID must contain the required packages to allow it to run as a NAT Gateway from startup as I have not written a userdata script yet that will provision it in this way.

The AMI that this module was using was based on Amazon Linux 1 and AWS have removed support for this image a long time ago.  AWS have totally removed the AMI now and have not replaced it with a modern Amazon linux base image.  Therefore, you will need to create your own base AMI as suggested above.

Eventually, I will add support to create a Amazon Linux 2023 base image in to a NAT Gateway, but as of yet I have not had time to sit and work that out.

## Dependencies

This modules requires that a VPC is already created with Public and Private subnets available.

### Public Subnets

These are the requirements for the data lookups to be successful.

 - A tag with the name of the subnet `Name = <name>-<region>-<availability_zone>` for example, `public-eu-west-2a`
 - A tag that distinguishes it from the Private subnet.  Default is `Type = "Public"`

### Private Subnets

 - A tag that distinguishes it from the Public subnet.  Default is `Type = "Private"`
 - A route table for each of the private subnets

This module is compatible with the terraform-aws-vpc module from the Terraform registry.  It has not been tested with any other VPC modules.

## Example

```
module "nat-gateway" {
  source = "https://github.com/tommo1296/terraform-aws-ec2-nat-gw"
  version = "0.3.0"

  ami_id = "ami-123"

  vpc_id = "vpc-12345"
}
```

This will create a working NAT Gateway using the AWS provided AMI.

You can add ingress and egress rules as required.  For example, you might want to allow SSH access to the box so you can use it as a bastion host or general administration uses.

```
module "nat-gateway" {
  source = "https://github.com/tommo1296/terraform-aws-ec2-nat-gw"
  version = "0.3.0"

  ami_id = "ami-123"

  vpc_id = "vpc-12345"

  custom_ingress_rules = [
    {
      description   = "Remote SSH Access"
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"
      cidr_blocks   = "1.1.1.1/32,2.2.2.2/32" # Comma separated string of cidr_blocks
    }
  ]
}
```

## Variables

| Variable | Description | Required | Default
| --- | --- | --- | --- |
| name | Name prefix for resources | no | nat-gateway
| vpc_id | ID of the required VPC | yes |  |
| tags | Additional tags to apply | no | {} |
| private_subnet_lookup_tags | For private subnet data lookup | no | { Type = "Private" } |
| public_subnet_lookup_tags | For public subnet data lookup | no | { Type = "Pulbic" } |
| availability_zone | Destination of the NAT Gateway instance | no | a |
| custom_ingress_rules | Custom ingress (see above example) | no | [] |
| custom_egrees_rules | Custom egress (see above example) | no | [] |
| ami_id | AMI ID containing NAT Gateway support pre-installed | yes |  |
| instance_type | Type of EC2 instance | no | t3a.nano |
| key_name | Key pair to apply | no |  |
