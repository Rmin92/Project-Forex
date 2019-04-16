#Network-Components

resource "aws_vpc" "raymin" {
  cidr_block = "10.0.0.0/16" # Defines overall VPC address space
  enable_dns_hostname = true # Enable DNS hostnames for this aws_vpc
  enable_dns-support = true # enable DNS resolving support for this aws_vpc
  tags{
      Name = "VPC-${var.environment}" # Tag VPC with name
  }
}

resource "aws_subnet" "pub-web-az-a" {
  availability_zone = "us-east-2b" # Define AZ for subnet
  cidr_block = "10.0.11.0/24" # Define CIDR-block for subnet
  map_public_ip_on_launc = true # Map public IP to deployed instances in this VPC
  vpc_id = "${aws_vpc.raymin.id}" # Link subnet to VPC
  tags {
      Name = "Subnet-US-East-2b-Web" # Tag subnet with name
  }
}

resource "aws_subnet" "pub-web-az-b" {
    availability_zone = "us-east-2b"
    cidr_block = "10.0.12.0/24"
    map_public_ip_on_launch = true
    vpc_id = "${aws_vpc.reymin.id}"
    tags {
      Name = "Subnet-US-East-2b-Web"
    }
}

resource "aws_subnet" "priv-db-az-a" {
  availability_zone = "us-east-2b"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  vpc_id = "${aws_vpc.raymin.id}"
  tags {
      Name = "Subnet-US-East-2b-DB"
  }
}

resource "aws_subnet" "priv-db-az-b" {
    availability_zone = "us-east-2b"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = false
    vpc_id = "${aws_vpc.raymin.id}"
      tags {
      Name = "Subnet-US-East-2b-DB"
  }
}
# This is to define the gateway
resource "aws_internet_gateway" "inetgw" {
  vpc_id = "${aws_vpc.raymin.id}"
  tags {
      Name = "IGW-VPC-${var.environment}-Default"
  }
}
# Setting up route tables to allow subnets to talk to each other
resource "aws_route_table" "us-default" {
  vpc_id = "${aws_vpc.raymin.id}"

  route {
      cidr_block = "0.0.0.0/0" # Defines default route
      gateway_id = "${aws_internet_gateway.inetgw.id}" # via IGW
  }

  tags {
      Name = "Route-Table-US-Default"
  }
}

resource "aws_route_table_association" "us-east-2b-public" {
  subnet_id = "${aws_subnet.pub-web-az-a.id}"
  route_table_id = "${aws_route_table.us-default.id}"
}

resource "aws_route_table_association" "us-east-2b-public" {
  subnet_id = "${aws_subnet.pub-web-az-b.id}"
  route_table_id = "${aws_route_table.us-default.id}"
}


resource "aws_route_table_association" "us-east-2b-private" {
  subnet_id = "${aws_subnet.priv-db-az-a.id}"
  route_table_id = "${aws_route_table.us-default.id}"
}

resource "aws_route_table_association" "us-east-2b-private" {
  subnet_id = "${aws_subnet.priv-db-az-b.id}"
  route_table_id = "${aws_route_table.us-default.id}"
}
