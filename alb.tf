module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = aws_vpc.my_vpc.id
  subnets = [
    aws_subnet.public_subnet1.id, 
    aws_subnet.public_subnet2.id
  ]
  security_groups    = [
    aws_security_group.ec2_sg1.id, 
    aws_security_group.ec2_sg2.id
    ]


  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        target1 = {
          target_id = aws_instance.web-01.id
          port = 80
        }
      target2 = {
          target_id = aws_instance.web-02.id
          port = 80
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "dev"
  }
}