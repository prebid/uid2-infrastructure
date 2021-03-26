locals {
  subnet_addresses = ["10.0.0.0/17", "10.0.128.0/17"]
  zone_suffixes = ["a", "c"] # fixed for now
}

resource "aws_vpc" "eks" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "eks"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks.id
}

resource "aws_route" "r" {
  route_table_id            = aws_vpc.eks.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}


resource "aws_subnet" "eks" {
  count = 2
  vpc_id     = aws_vpc.eks.id
  cidr_block = local.subnet_addresses[count.index]
  availability_zone = "${var.region}${local.zone_suffixes[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks"
    "kubernetes.io/role/elb" = "1"
  }
}
