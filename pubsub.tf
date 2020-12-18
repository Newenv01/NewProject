locals {
   az_list = "${data.aws_availability_zones.azs.names}"
   pub_sub_ids = "${aws_subnet.primary.*.id}"
}

resource "aws_vpc" "new_vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "primary" {
  count = "${length(local.az_list)}"
  vpc_id = "${aws_vpc.new_vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"
  availability_zone = "${local.az_list[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name = "new_igw"
  }
}

resource "aws_route_table" "prt" {
  vpc_id = aws_vpc.new_vpc.id

  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "new_prt_route"
  }
}

resource "aws_route_table_association" "pub_sub_asso" {
  count          = "${length(local.az_list)}"
  subnet_id      = "${local.pub_sub_ids[count.index]}"
  route_table_id = "${aws_route_table.prt.id}"
}
