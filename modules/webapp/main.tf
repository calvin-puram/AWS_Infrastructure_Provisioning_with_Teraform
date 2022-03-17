


resource "aws_default_security_group" "myapp-main-sg" {
  vpc_id = var.vpc_id
  

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [var.my_ip]
  }

  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "myapp-main-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_image]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_name)
}

resource "aws_instance" "webapp" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  availability_zone = var.az
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_default_security_group.myapp-main-sg.id]
  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "${var.vpc_dev}-webapp"
  } 
}  
