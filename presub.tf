resource "aws_subnet" "privatesub" {
  count = "${length(slice(local.az_list,0,2))}"
  vpc_id = "${aws_vpc.new_vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_list))}"
  availability_zone = "${local.az_list[count.index]}"

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

resource "aws_eip" "pnat" {
  instance = aws_instance.web.id
  vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.pnat.id}"
  subnet_id     = "${local.pub_sub_ids[0]}"

  tags = {
    Name = "NAT GW"
  }
}