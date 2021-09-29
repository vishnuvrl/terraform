resource "aws_security_group" "rds" {
  name        = "rds_sg"
  description = "Allow rds inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
      description      = "http from VPC"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = ["${aws_security_group.tomcat.id}"]
      self = false
    }

    ingress {
      description      = "http from VPC"
      from_port        = 3306
      to_port          = 3306
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
    Name = "${var.envname}-rds-sg"
  }
}

