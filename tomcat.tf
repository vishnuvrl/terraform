resource "aws_security_group" "tomcat" {
  name        = "tomcat_sg"
  description = "Allow tomcat inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress  {
      description      = "tomcat from VPC"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = ["${aws_security_group.alb.id}"]
      self = false
    }

    ingress  {
      description      = "tomcat from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = ["${aws_security_group.bastion.id}"]
      self = false
    }


  

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
      description = ""
    }
  ]

  tags = {
    Name = "${var.envname}-tomcat-sg"
  }
}

data "template_file" "user_data" {
  template = "${file("tomcat_install.sh")}"
} 

#tomcat-instance
resource "aws_instance" "tomcat" {
  ami           = var.ami
  instance_type = var.type
  subnet_id = aws_subnet.privatesubnet[0].id
  key_name = aws_key_pair.petclinic.id
  vpc_security_group_ids = ["${aws_security_group.tomcat.id}"]
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = "${var.envname}-tomcat"
  }
}
