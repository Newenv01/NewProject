variable "SEC" {
   type = string
   default = "zs7iFS1yiCA0YaAx+Pa5LbNYWI4pk4bYjoe5ze91"
}
variable "ACC" {
   type = string
   default = "AKIAYXBNRIPGHZY5WNAQ"
}

variable "AMIS" {
   type = string
   default = "us-west-2"
}

variable "AMID" {
   type = map
   default = {
        us-west-2 = "ami-087c2c50437d0b80d"
        us-west-2c = "ami-02f147dfb8be58a10"
        us-east-1e = "ami-098f16afa9edf40be"
   }
}

variable "vpc_cidr" {
   description = "VPC Description"
   type = "string"
   default = "10.20.0.0/16"
}