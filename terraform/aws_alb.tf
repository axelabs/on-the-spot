# Create a new load balancer

resource "aws_alb" "webapp" {
  name            = "webapp"
  internal        = false
  security_groups = ["${aws_security_group.alb_webapp.id}"]
  subnets         = ["${aws_subnet.andromeda-subzero.id}", "${aws_subnet.andromeda-subone.id}"]
}

resource "aws_alb_target_group" "webapp" {
  name     = "webapp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.andromeda.id}"
}

resource "aws_alb_listener" "webapp" {
  load_balancer_arn = "${aws_alb.webapp.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.webapp.id}"
    type             = "forward"
  }
}
