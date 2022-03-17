

resource "aws_subnet" "myapp_subnet" {
  vpc_id     = var.vpc_id 
  cidr_block = var.vpc_subnet_cidr
  availability_zone = var.az

  tags = {
    Name = "${var.vpc_dev}-myapp_subnet"
  }
}


resource "aws_internet_gateway" "myapp_gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.vpc_dev}-myapp_gw"
  }
}

resource "aws_default_route_table" "myapp_main-rt" {
  default_route_table_id = var.default_rt_id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp_gw.id
  }

  
  tags = {
    Name = "${var.vpc_dev}-myapp_main-rt"
  }
}

resource "aws_route_table_association" "myapp-rta" {
  subnet_id      = aws_subnet.myapp_subnet.id
  route_table_id = aws_default_route_table.myapp_main-rt.id
}