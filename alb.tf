resource "aws_lb" "main" {
  name               = "${var.name}-${var.env}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets
  enable_deletion_protection = var.enable_deletion_protection
  security_groups   = [aws_security_group.main.id]

  tags = merge(
    var.tags,
    { Name = "${var.name}-${var.env}" }
  )
}

# fixed response
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>503 - invalid request</h1>"  # put it in  html format
      status_code  = "503"
    }
  }
}

## vpc security group creation
resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}"
  description = "${var.name}-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description      = "APP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.allow_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-${var.env}" }
  )
}