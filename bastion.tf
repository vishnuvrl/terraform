resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
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
    Name = "${var.envname}-bastion-sg"
  }
}

#key-pair
resource "aws_key_pair" "petclinic" {
  key_name   = "petclinic-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRW4GX+Wvy7Y/zCDRxSQcE/UtVTqB/cze5WZWIBO//TG6EkYbxTYng7RvOoBlNu4ThyR91UAZ1J46ZQ7bw07E0sg4OdBddGmOp+GlZetnRebpjbQPDc2pR1Uf7Hv5UoVRLMpbp82KyipNVgQmwbgCvU4e7AUHl1jp5Y9CNFkyKqEEFORfmkxlSNcdpClctgjWOOCCunwJKim5EXkeREQWfgvCYPAv52brhdX0Z+xhNUiywrVTmkvqUNXngKZbciVODUw+ZKRk04vECOvewgt1syWgc3qAUFfnyqwnyG92BMw4RsVSy0nqY8amJQ2jDiYocUBRRO5V7kV4rd9VbA++YGsdIMkgUeJLSGMps+ONh+H1W2JW7w1iQRmS4Pp3epxrj261e74DWhHInv4w4N9AIuXOxeR2X39sOIUvOI8R5TJPTeLiVsBh7RFji2aEa5CXLAv9Gascbok2/mCIw6te1tXfPvJ5lHwn4QtQhE1gj/yeRE4W6zVfwYSyMUv2H6Q0= vishn@LAPTOP-PKHD7QS7"
}

#instance-bastion
resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.type
  subnet_id = aws_subnet.publicsubnet[0].id
  key_name = aws_key_pair.petclinic.id
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  tags = {
    Name = "${var.envname}-bastion"
  }
}

