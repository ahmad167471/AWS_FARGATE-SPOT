##########################################################
# network.tf – New VPC, Subnets, and Internet Gateway
##########################################################

########################################
# VPC
########################################
resource "aws_vpc" "ahmad_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ahmad-vpc"
    Env  = "dev"
  }
}

########################################
# Public Subnets in two AZs
########################################
resource "aws_subnet" "ahmad_subnet_1" {
  vpc_id                  = aws_vpc.ahmad_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ahmad-subnet-1"
    Env  = "dev"
  }
}

resource "aws_subnet" "ahmad_subnet_2" {
  vpc_id                  = aws_vpc.ahmad_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ahmad-subnet-2"
    Env  = "dev"
  }
}

########################################
# Internet Gateway
########################################
resource "aws_internet_gateway" "ahmad_igw" {
  vpc_id = aws_vpc.ahmad_vpc.id

  tags = {
    Name = "ahmad-igw"
    Env  = "dev"
  }
}

########################################
# Public Route Table
########################################
resource "aws_route_table" "ahmad_public_rt" {
  vpc_id = aws_vpc.ahmad_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ahmad_igw.id
  }

  tags = {
    Name = "ahmad-public-rt"
    Env  = "dev"
  }
}

########################################
# Route Table Associations
########################################
resource "aws_route_table_association" "subnet1_assoc" {
  subnet_id      = aws_subnet.ahmad_subnet_1.id
  route_table_id = aws_route_table.ahmad_public_rt.id
}

resource "aws_route_table_association" "subnet2_assoc" {
  subnet_id      = aws_subnet.ahmad_subnet_2.id
  route_table_id = aws_route_table.ahmad_public_rt.id
}
