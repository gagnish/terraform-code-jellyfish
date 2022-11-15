
resource "aws_instance" "dev-instance" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t2.micro"
  count         = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  vpc_security_group_ids = [ aws_security_group.lb.id ]
  key_name = "myubuntukey"
  tags = {
    Name = "dev-ec2-server" 
  }
}
