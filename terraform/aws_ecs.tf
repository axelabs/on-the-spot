# EC2 Container Service resources

# Cluster
resource "aws_ecs_cluster" "webapp" {
  name = "webapp"
}

# Define the task and it's container properties
resource "aws_ecs_task_definition" "webapp" {
  family = "webapp"
  network_mode = "host"
  container_definitions = <<DEFINITION
[
  {
    "name": "webapp",
    "image": "training/webapp:latest",
    "cpu": 128,
    "memory": 128,
    "portMappings": [
      {
        "hostPort": 5000,
        "containerPort": 5000,
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION
}

# Data used for task version tracking in the service
data "aws_ecs_task_definition" "webapp" {
  task_definition = "${aws_ecs_task_definition.webapp.family}"
}

# Define the service and associate it with a load balancer
resource "aws_ecs_service" "webapp" {
  name = "webapp"
  cluster = "${aws_ecs_cluster.webapp.id}"
  iam_role = "${aws_iam_role.ecsServiceRole.id}"
  depends_on = ["aws_iam_role.ecsServiceRole", "aws_alb_listener.webapp"]

  # Number of containers to run
  desired_count = 2

  # Use the latest revision of the above task for the service
  task_definition = "${aws_ecs_task_definition.webapp.family}:${max("${aws_ecs_task_definition.webapp.revision}", "${data.aws_ecs_task_definition.webapp.revision}")}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.webapp.arn}"
    container_name = "webapp"
    container_port = 5000
  }
}
