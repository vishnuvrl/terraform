#creating the vpc
resource "aws_vpc" "petclinic" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.envname
  }
}


#creating the subnets
resource "aws_subnet" "publicsubnet" {
  count = length(var.azs)  
  vpc_id     = aws_vpc.petclinic.id
  cidr_block = element(var.pubsubnets,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.envname}-pubsubnet-${count.index+1}"
  }
}

#creating the private subnet
resource "aws_subnet" "privatesubnet" {
  count = length(var.azs)  
  vpc_id     = aws_vpc.petclinic.id
  cidr_block = element(var.privatesubnets,count.index)
  availability_zone = element(var.azs,count.index)

  tags = {
    Name = "${var.envname}-prisubnet-${count.index+1}"
  }
}

#creating the data subnets
resource "aws_subnet" "datasubnet" {
  count = length(var.azs)  
  vpc_id     = aws_vpc.petclinic.id
  cidr_block = element(var.datasubnets,count.index)
  availability_zone = element(var.azs,count.index)

  tags = {
    Name = "${var.envname}-datasubnet-${count.index+1}"
  }
}

#igw and vpc
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.petclinic.id

  tags = {
    Name = "${var.envname}-igw"
  }
}

#elasticip
resource "aws_eip" "natIp" {
  vpc      = true

  tags = {
    Name = "${var.envname}-natIp"
  }
}


#nat-gw to vpc
resource "aws_nat_gateway" "natGw" {
  allocation_id = aws_eip.natIp.id
  subnet_id     = aws_subnet.publicsubnet[0].id

  tags = {
    Name = "${var.envname}-natGw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  #depends_on = [aws_internet_gateway.example]
}

#public-route-table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.petclinic.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    } 
  tags = {
    Name = "${var.envname}-pub-rt"
  }
}

#private-route-table
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.petclinic.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.natGw.id
    } 
  tags = {
    Name = "${var.envname}-pri-rt"
  }
}

resource "aws_route_table" "data_rt" {
  vpc_id = aws_vpc.petclinic.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.natGw.id
    } 
  tags = {
    Name = "${var.envname}-data-rt"
  }
}

#association
resource "aws_route_table_association" "pubsubnetassociate" {
  count = length(var.pubsubnets)
  subnet_id      = element(aws_subnet.publicsubnet.*.id,count.index)
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "prisubnetassociate" {
  count = length(var.privatesubnets)
  subnet_id      = element(aws_subnet.privatesubnet.*.id,count.index)
  route_table_id = aws_route_table.pri_rt.id
}

resource "aws_route_table_association" "datasubnetassociate" {
  count = length(var.datasubnets)
  subnet_id      = element(aws_subnet.datasubnet.*.id,count.index)
  route_table_id = aws_route_table.data_rt.id
}