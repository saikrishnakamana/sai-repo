provider "aws" {
 region ="eu-west-1" 
}
resource "aws_instance" "test" {
    ami = "ami-02141377eee7defb9"
    instance_type = "t2.micro"
    user_data= file("string")
}