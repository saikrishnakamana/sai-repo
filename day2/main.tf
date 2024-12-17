# Create VPC
resource "aws_vpc" "dev_local" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev_vpc"
  }
}

# Create subnet
resource "aws_subnet" "dev_local" {
  vpc_id     = aws_vpc.dev_local.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "dev_subnet"
  }
}

# Create Internet Gateway and attach to VPC
resource "aws_internet_gateway" "dev_local" {
  vpc_id = aws_vpc.dev_local.id
}

# Create a route table and add route
resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_local.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_local.id
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "dev_local" {
  subnet_id      = aws_subnet.dev_local.id
  route_table_id = aws_route_table.dev_rt.id
}

# Create Security Group
resource "aws_security_group" "allow_tls" {
  name   = "allow_tls"
  vpc_id = aws_vpc.dev_local.id
  tags = {
    Name = "dev_sg"
  }

  # Ingress rule for HTTP (port 80)
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for SSH (port 22)
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic within the VPC
  ingress {
    description = "Allow all traffic from within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

# Create EC2 Instance
resource "aws_instance" "dev" {
  ami             = "ami-0fcc0bef51bad3cb2"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.dev_local.id
  key_name        = "friends"
  vpc_security_group_ids   = [aws_security_group.allow_tls.id] # Attach security group
  tags = {
    Name ="dev_ec222"
  }
}
# Create EC2 Instance
resource "aws_instance" "dev1"{
  ami             = "ami-0fcc0bef51bad3cb2"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.dev_local.id
  key_name        = "friends"
  vpc_security_group_ids   = [aws_security_group.allow_tls.id] # Attach security group
  tags = {
    Name ="dev_ec233"
  }
}