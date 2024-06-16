resource "aws_vpc" "wp" {
    cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "subnet-1a" {
  vpc_id     = "${aws_vpc.wp.id}"
  cidr_block = var.subnet_cidr_block[0]
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true
}


resource "aws_subnet" "subnet-1b" {
  vpc_id     = "${aws_vpc.wp.id}"
  cidr_block = var.subnet_cidr_block[1]
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true
}


resource "aws_subnet" "subnet-2a" {
  vpc_id     = "${aws_vpc.wp.id}"
  cidr_block = var.subnet_cidr_block[2]
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = false
}


resource "aws_subnet" "subnet-2b" {
  vpc_id     = "${aws_vpc.wp.id}"
  cidr_block = var.subnet_cidr_block[3]
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "wp-gw" {
  vpc_id = "${aws_vpc.wp.id}"
}

resource "aws_route_table" "subnet-1a-route" {
  vpc_id = "${aws_vpc.wp.id}"

  route {
    cidr_block = var.route_table_cidr
    gateway_id = "${aws_internet_gateway.wp-gw.id}"
  }
}

resource "aws_route_table" "subnet-1b-route" {
  vpc_id = "${aws_vpc.wp.id}"

  route {
    cidr_block = var.route_table_cidr
    gateway_id = "${aws_internet_gateway.wp-gw.id}"
  }
}

resource "aws_route_table_association" "subnet-1a-asso" {
  subnet_id      = aws_subnet.subnet-1a.id
  route_table_id = aws_route_table.subnet-1a-route.id
}

resource "aws_route_table_association" "subnet-1b-asso" {
  subnet_id      = aws_subnet.subnet-1b.id
  route_table_id = aws_route_table.subnet-1b-route.id
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.wp-gw]
}

resource "aws_nat_gateway" "wp-gw-1" {
  allocation_id = "${aws_eip.nat-eip.id}"
  subnet_id     = "${aws_subnet.subnet-1a.id}"
}


resource "aws_nat_gateway" "wp-gw-2" {
  allocation_id = "${aws_eip.nat-eip.id}"
  subnet_id     = "${aws_subnet.subnet-1b.id}"
}

resource "aws_route_table" "subnet-2a-route" {
  vpc_id = "${aws_vpc.wp.id}"

  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_nat_gateway.wp-gw-1.id

  }
  
}

resource "aws_route_table" "subnet-2b-route" {
  vpc_id = "${aws_vpc.wp.id}"

  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_nat_gateway.wp-gw-1.id

  }
  
}

resource "aws_route_table_association" "subnet-2a-asso" {
  subnet_id      = aws_subnet.subnet-2a.id
  route_table_id = aws_route_table.subnet-2a-route.id
}

resource "aws_route_table_association" "subnet-2b-asso" {
  subnet_id      = aws_subnet.subnet-2b.id
  route_table_id = aws_route_table.subnet-2b-route.id
}