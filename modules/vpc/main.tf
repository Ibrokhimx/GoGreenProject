resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  tags = var.tags
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  }