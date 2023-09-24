resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "webapp"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
    vpc_id    = aws_vpc.my_vpc.id
    tags = {
        Name = "webapp"
    }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.16.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch  = true
  tags = {
    Name = "webapp"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.32.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch  = true
  tags = {
    Name = "webapp"
  }
}

resource "aws_route_table" "public_rtb" {
    vpc_id       = aws_vpc.my_vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet-gateway.id
          }
    tags = {
        Name = "webapp"
  }
}

resource "aws_route_table_association" "public_subn_association1" {
    subnet_id           = aws_subnet.public_subnet1.id
    route_table_id      = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_subn_association2" {
    subnet_id           = aws_subnet.public_subnet2.id
    route_table_id      = aws_route_table.public_rtb.id
}