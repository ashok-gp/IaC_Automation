data "aws_ami" "amazon-linux-2" {
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_security_group" "ec2_sg1" {
  name   = "ec2-sg1"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg2" {
  name   = "ec2-sg2"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web-01" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"
  key_name               = "ashok_sing"
  vpc_security_group_ids = [
        aws_security_group.ec2_sg1.id, 
        aws_security_group.ec2_sg2.id
    ]
  
  subnet_id              = aws_subnet.public_subnet1.id
  user_data  =   "${file("init.sh")}"

  tags = {
    Name    = "app-01"
    Environment = "dev"
  }
}

resource "aws_instance" "web-02" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"
  key_name               = "ashok_sing"
  vpc_security_group_ids =  [
        aws_security_group.ec2_sg1.id, 
        aws_security_group.ec2_sg2.id
    ]
  subnet_id              = aws_subnet.public_subnet2.id
  user_data  =   "${file("init.sh")}"
  tags = {
    Name    = "app-02"
    Environment = "dev"
  }
}