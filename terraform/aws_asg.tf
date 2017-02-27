# Define the Autoscaling group for the ECS cluster


# The base AMI will be Amazon's latest ECS optimized image
data "aws_ami" "ecs_os" {
  most_recent = true
  filter {
    name = "name"
    values = ["*amzn-ami-2016.*-amazon-ecs-optimized*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["591542846629"]
}

# Profile needed for launch config
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs_instance_profile"
  roles = ["${aws_iam_role.ecs_instance.name}"]
}

# Launch configuration
resource "aws_launch_configuration" "ecs_instance" {
  name = "ecs_instance"
  image_id = "${data.aws_ami.ecs_os.id}"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.id}"
  security_groups = ["${aws_security_group.ecs_instance.id}"]
  # User data is defined in its own file
  user_data = "${file("userdata.sh")}"
  key_name = "access"
}

# Autoscaling Group
resource "aws_autoscaling_group" "ecs_webapp" {
    name = "ecs_webapp"
    launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
    lifecycle { create_before_destroy = true }
    vpc_zone_identifier = ["${aws_subnet.andromeda-subzero.id}", "${aws_subnet.andromeda-subone.id}"]
    min_size = 2
    max_size = 3
}
