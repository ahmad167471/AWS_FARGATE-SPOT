##########################################################
# alb.tf – Fixed for ahmad_vpc setup
##########################################################

########################################
# ALB Security Group
########################################
resource "aws_security_group" "alb_sg" {
  name        = "ahmad-ecs-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.ahmad_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ahmad-ecs-alb-sg"
    Env  = "dev"
  }
}

########################################
# Application Load Balancer
########################################
resource "aws_lb" "ecs_alb" {
  name               = "ahmad-ecs-alb"
  load_balancer_type = "application"
  internal           = false

  # ✅ FIXED SUBNET REFERENCES
  subnets = [
    aws_subnet.ahmad_subnet_1.id,
    aws_subnet.ahmad_subnet_2.id
  ]

  security_groups = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "ahmad-ecs-alb"
    Env  = "dev"
  }
}

########################################
# Target Group
########################################
resource "aws_lb_target_group" "ecs_tg" {
  name        = "ahmad-ecs-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ahmad_vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ahmad-ecs-tg"
    Env  = "dev"
  }
}

########################################
# Listener
########################################
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}