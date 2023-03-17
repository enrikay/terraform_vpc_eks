# Create a VPC


resource "aws_vpc" "money-pal" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dmoney-pal-vpc"
  }
}

resource "aws_internet_gateway" "money-pal-IGW" {
  vpc_id = aws_vpc.money-pal.id
  tags = {
    Name = "money-pal-IGW"
  }
}

resource "aws_route_table" "money-pal-pub-RT" {
  vpc_id = aws_vpc.money-pal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.money-pal-IGW.id
  }

  tags = {
    Name = "money-pal-pub-RT"
  }
}



resource "aws_subnet" "pub-1" {
  vpc_id                  = aws_vpc.money-pal.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "money-pal-pub-1"
  }
}

resource "aws_subnet" "pub-2" {
  vpc_id                  = aws_vpc.money-pal.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "money-pal-pub-2"
  }
}


resource "aws_subnet" "priv-1" {
  vpc_id                  = aws_vpc.money-pal.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "money-pal-priv-1"
  }
}


resource "aws_subnet" "priv-2" {
  vpc_id                  = aws_vpc.money-pal.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "money-pal-priv-2"
  }
}


resource "aws_route_table_association" "money-pal-pub-1-a" {
  subnet_id      = aws_subnet.pub-1.id
  route_table_id = aws_route_table.money-pal-pub-RT.id
}

resource "aws_route_table_association" "money-pal-pub-2-a" {
  subnet_id      = aws_subnet.pub-2.id
  route_table_id = aws_route_table.money-pal-pub-RT.id
}



