provider "aws"{
  region     = "us-east-1"
  access_key = "your_access_key"
  secret_key = "your_secret_key" #keys no  need to configure here it will call from .aws folder from local
}
Step 2: In that directory, create another file named demo_datasource.tf and use the code given below.


data "aws_vpc" "vpc" {
  id = vpc_id
}


data "aws_subnet" "subnet" {
  id = subnet_id
}

resource "aws_security_group" "sg" {  # here we are creating security grop by calling exicting vpc so we can use data source block
  name = "sg"
  vpc_id = data.aws_vpc.vpc.id
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0"]
     description      = ""
     from_port        = 22
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0"]
      description      = ""
      from_port        = 0
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
}

resource "aws_instance" "dev" {
    ami = data.aws_ami.amzlinux.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.dev.id
    security_groups = [ data.aws_security_group.dev.id ]
tags = {
    Name = "DataSource- Instance"
  }
}
In the above block of code, we are using a vpc and a subnet that is already created on AWS using its console. Then using data block, which refers to data sources, that is, a vpc and a subnet. By doing this, we are retrieving the information about the vpc and subnet that are created outside of terraform configuration. Then creating a security group that uses vpc_id that was fetched using data block. Further creating the EC2 instance that uses the subnet_id that was also fetched using data block.
So, in this example, data source is being used to get data about the vpc and subnet that were not created using terraform script and using this data further for creating an EC2.


  case-2
  we can call AMI id also by using data source block 

  data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}








  