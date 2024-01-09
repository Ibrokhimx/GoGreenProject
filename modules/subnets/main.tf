resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  for_each                = var.subnets
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = each.value.name
  }
}

# resource "aws_subnet" "subnet" {
#   vpc_id                  = var.vpc_id
#   cidr_block              = var.cidr_subnet
#   availability_zone       = var.az_subnet
#   map_public_ip_on_launch = var.public
#   tags                    = var.tags_subnet
# }
