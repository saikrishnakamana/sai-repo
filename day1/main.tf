resource "aws_instance" "name" {
  ami ="ami-0d40bc8df1aa09978"
  instance_type = "t2.micro"
  key_name = "caif"
}