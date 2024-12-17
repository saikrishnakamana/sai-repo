# create instance 

resource "aws_instance" "dev_local" {
    ami = "ami-0fcc0bef51bad3cb2"
    instance_type = "dev-ec2"
    subnet_id = aws_subnet.dev.id
    key_name = "friends"
    tags = {
      Name = "dev-ec2"
    }
}