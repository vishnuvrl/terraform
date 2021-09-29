resource "aws_security_group" "alb" {
  name        = "alb_sg"
  description = "Allow alb inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress = [
    {
      description      = "http from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

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
    Name = "${var.envname}-alb-sg"
  }
}

