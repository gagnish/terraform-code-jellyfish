#create a ec2 instance with existing vpc subnet
resource "aws_instance" "dev-instance" {
  ami           = "ami-002068ed284fb165b"
  instance_type = "t2.micro"
  count         = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  vpc_security_group_ids = [ aws_security_group.lb.id ]
  key_name = "dev-server"
  tags = {
    Name = "dev-ec2-server"
  }
  connection {    
       type     = "ssh"    
       user     = "ec2-user"    
       private_key = file("./dev-server.pem")    
       host     = self.public_ip  
  }
  provisioner "remote-exec" {    
    inline = [      
      "sudo amazon-linux-extras enable nginx1", 
      "sudo yum install -y nginx",
      "sudo service nginx restart",
      "sudo systemctl enable nginx.service", 
      "sudo service nginx status",
      ]  
  }
}

#terraform destroy -target RESOURCE_TYPE.NAME