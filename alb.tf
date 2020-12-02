resource "aws_alb" "main" {
  name            = "helloworld-alb"
  subnets         = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.ecs_tasks.id]
}

resource "aws_alb_target_group" "app" {
  name        = "helloworld-tg"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
