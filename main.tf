provider "aws" {
   region     =  "${var.AMIS}"
   access_key =  "${var.ACC}"
   secret_key =  "${var.SEC}"
}

resource "aws_instance" "web" {
  ami           = "${lookup(var.AMID, var.AMIS)}"
  instance_type = "t2.micro"
  #availability_zone = "${data.aws_availability_zones.totaz.names[count.index]}"
  key_name = "Nexus"
  tags = {
       Environment = "${terraform.workspace}"
  }
}