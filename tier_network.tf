module "gogreen_vpc" {
  source               = "./modules/vpc"
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

module "public_subnets" {
  source  = "./modules/subnets"
  vpc_id  = module.gogreen_vpc.vpc_id
  subnets = var.public_subnets
  prefix  = var.prefix
}
module "private_subnets" {
  source  = "./modules/subnets"
  vpc_id  = module.gogreen_vpc.vpc_id
  subnets = var.private_subnets
  prefix  = var.prefix
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.gogreen_vpc.vpc_id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = module.gogreen_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-public-rt"
  }
}

resource "aws_route_table_association" "rta" {
  for_each = var.public_subnets
  #subnet_id = aws_subnet.public_subnet[each.key].id
  subnet_id      = module.public_subnets.subnet_ids[each.key]
  route_table_id = aws_route_table.rt.id
}

resource "aws_nat_gateway" "ngw" {
  for_each  = var.public_subnets
  subnet_id = module.public_subnets.subnet_ids[each.key]
  #subnet_id     = aws_subnet.public_subnet[each.key].id
  allocation_id = aws_eip.nat[each.key].id
}
resource "aws_eip" "nat" {
  for_each = var.public_subnets
  domain   = "vpc"
}
resource "aws_route_table" "rt-nat" {
  vpc_id   = module.gogreen_vpc.vpc_id
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
  for_each = var.nat-rta
  #subnet_id = aws_subnet.private_subnet[each.value.subnet_id].id
  subnet_id      = module.private_subnets.subnet_ids[each.value.subnet_id]
  route_table_id = aws_route_table.rt-nat[each.value.route_table_id].id
}

# resource "aws_key_pair" "WEB_tier" {
#   key_name   = "WEB_tier"
#   public_key = file("~/.ssh/cloud_2024.pem.pub")
#   lifecycle {
#     ignore_changes = [public_key]
#   }
# }
# resource "aws_key_pair" "APP_tier" {
#   key_name   = "APP_tier"
#   public_key = file("~/.ssh/cloud_2024.pem.pub")
#   lifecycle {
#     ignore_changes = [public_key]
#   }
# }





