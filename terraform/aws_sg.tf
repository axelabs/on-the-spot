# Define the Security Groups

# SG for ECS cluster instances
resource "aws_security_group" "ecs_instance" {
  name        = "ecs_instance"
  description = "Groups all ecs instances"
  vpc_id = "${aws_vpc.andromeda.id}"
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow webapp access directly
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 5000
    to_port   = 5000

    security_groups = [
      "${aws_security_group.alb_webapp.id}",
    ]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# SG for the Application Loadbalancer
resource "aws_security_group" "alb_webapp" {
  name        = "alb_webapp"
  description = "Inbound rules to the webapp ALB"
  vpc_id = "${aws_vpc.andromeda.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

