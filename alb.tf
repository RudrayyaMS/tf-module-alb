resource "aws_lb" "main" {
  name               = "${var.name}-${var.env}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets
  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    var.tags,
    { Name = "${var.name}-${var.env}" }
  )
}