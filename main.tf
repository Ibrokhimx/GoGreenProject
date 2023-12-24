resource "aws_vpc" "vpc" {
  cidr_block           = "54.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.public_subnets
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  for_each          = var.private_subnets
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  #map_public_ip_on_launch = true

  tags = {
    Name = "${each.value.name}"
  }
}

# module "subnets" {
#   source  = "app.terraform.io/pitt412/subnets/aws"
#   version = "1.0.4"
#   vpc_id  = aws_vpc.vpc.id
#   subnets = var.subnets
#   prefix  = var.prefix
# }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-public-rt"
  }
}

resource "aws_route_table_association" "rta" {
  for_each  = var.public_subnets
  subnet_id = aws_subnet.public_subnet[each.key].id
  #subnet_id      = [module.subnets.subnet_ids["public_subnets"]]
  route_table_id = aws_route_table.rt.id
}

# resource "aws_nat_gateway" "ngw" {
#   for_each      = var.public_subnets
#   subnet_id     = aws_subnet.public_subnet[each.key].id
#   allocation_id = aws_eip.nat[each.key].id
# }
resource "aws_nat_gateway" "ngw" {
  for_each      = var.public_subnets
  subnet_id     = aws_subnet.public_subnet[each.key].id
  allocation_id = aws_eip.nat[each.key].id
}
resource "aws_eip" "nat" {
  for_each = var.public_subnets
  domain   = "vpc"
}
resource "aws_route_table" "rt-nat" {
  vpc_id   = aws_vpc.vpc.id
  for_each = aws_nat_gateway.ngw
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[each.key].id
  }
  tags = {
    Name = "${var.prefix}-private-rt"
  }
}
resource "aws_route_table_association" "rt-nat" {
  for_each  = var.nat-rta
  subnet_id = aws_subnet.private_subnet[each.key].id
  #subnet_id      = [module.subnets.subnet_ids["public_subnets"]]
  route_table_id = aws_route_table.rt-nat[each.key].id
}
# resource "aws_route_table_association" "rt-nat-app1B" {
#   for_each  = var.private_subnets
#   subnet_id = aws_subnet.private_subnet["Private_Sub_APP_1B"].id
#   #subnet_id      = [module.subnets.subnet_ids["public_subnets"]]
#   route_table_id = aws_route_table.rt-nat["Public_Sub_WEB_1B"].id
# }
data "aws_ami" "amazon-linux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
}