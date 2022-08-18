#_________________________________
#          VPC
#---------------------------------
resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#_________________________________
#          IGW
#---------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#_________________________________
#          Public Subnets
#---------------------------------

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3,0)
  availability_zone = data.aws_availability_zones.AZs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-1-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3,1)
  availability_zone = data.aws_availability_zones.AZs.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-2-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_subnet" "public-3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3,2)
  availability_zone = data.aws_availability_zones.AZs.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public-3-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#_________________________________
#          Private Subnets
#---------------------------------

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3,3)
  availability_zone = data.aws_availability_zones.AZs.names[0]

  tags = {
    Name    = "Private-1-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3,4)
  availability_zone = data.aws_availability_zones.AZs.names[1]

  tags = {
    Name    = "Private-2-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_subnet" "private-3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3,5)
  availability_zone = data.aws_availability_zones.AZs.names[2]

  tags = {
    Name    = "Private-3-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#__________________________________
#           EIP
#----------------------------------

resource "aws_eip" "ngw" {
  vpc      = true
  tags = {
    Name    = "EIP-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#__________________________________
#            NGW
#----------------------------------

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public-2.id

  tags = {
    Name    = "${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#__________________________________
#          Public-RTB
#----------------------------------

resource "aws_route_table" "Public-RTB" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "Public-RTB-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }

}

#__________________________________
#          Private-RTB
#----------------------------------

resource "aws_route_table" "Private-RTB" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name    = "Private-RTB-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }

}

#_____________________________________________
#          Public-RTB-Association
#---------------------------------------------

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.Public-RTB.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.Public-RTB.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.Public-RTB.id
}

#________________________________________________
#          Private-RTB-Association
#------------------------------------------------

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.Private-RTB.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.Private-RTB.id
}

resource "aws_route_table_association" "private-3" {
  subnet_id      = aws_subnet.private-3.id
  route_table_id = aws_route_table.Private-RTB.id
}

#_______________________________________________
#        Security Group For Bastion Serer
#-----------------------------------------------

resource "aws_security_group" "Bastion" {
  name        = "Bastion-${var.project}-${var.env}"
  description = "Allow SSH Traffic only"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "Bastion-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#______________________________________________
#        Security Group For Frontend Server
#----------------------------------------------


resource "aws_security_group" "WebAccess" {
  name        = "WebAccess-${var.project}-${var.env}"
  description = "Allow HTTP and HTTPS Traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.Bastion.id]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "WebAccess-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#______________________________________________
#        Security Group For Backend Server
#----------------------------------------------

resource "aws_security_group" "DB_Access" {
  name        = "DB_Access-${var.project}-${var.env}"
  description = "Allow MySql Access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
  
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.Bastion.id]
  }

  ingress {
  
    from_port        = 3308
    to_port          = 3308
    protocol         = "tcp"
    security_groups = [aws_security_group.WebAccess.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "DB_Access-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}


#______________________________________________
#        Creating Key pair
#----------------------------------------------

resource "aws_key_pair" "myKey" {
  key_name   = "myKey"
  public_key = file("key.pub")
  
  tags = {
    Name    = "${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#______________________________________________
#        Creating EC2 instance for bastion
#----------------------------------------------

resource "aws_instance" "Bastion" {
  ami           = var.ami
  instance_type = var.type
  key_name = aws_key_pair.myKey.key_name
  vpc_security_group_ids = [aws_security_group.Bastion.id]
  subnet_id = aws_subnet.public-1.id

  tags = {
    Name    = "Bastion-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }

}


#______________________________________________
#        Creating EC2 instance for Frontend
#----------------------------------------------

resource "aws_instance" "webserver" {
  ami           = var.ami
  instance_type = var.type
  key_name = aws_key_pair.myKey.key_name
  vpc_security_group_ids = [aws_security_group.WebAccess.id]
  subnet_id = aws_subnet.public-2.id

  tags = {
    Name    = "Webserver-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}

#______________________________________________
#        Creating EC2 instance for Backend
#----------------------------------------------

resource "aws_instance" "dbserver" {
  ami           = var.ami
  instance_type = var.type
  key_name = aws_key_pair.myKey.key_name
  vpc_security_group_ids = [aws_security_group.DB_Access.id]
  subnet_id = aws_subnet.private-1.id

  tags = {
    Name    = "dbserver-${var.project}-${var.env}"
    Project = var.project
    Env     = var.env
  }
}
