# Define IAM roles and policies

### ECS instance role ###
# Trust definition for the instance role
data "aws_iam_policy_document" "trust" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Define the instance role and apply the above trust
resource "aws_iam_role" "ecs_instance" {
    name = "ecs_instance"
    assume_role_policy = "${data.aws_iam_policy_document.trust.json}"
}

# Actual policy to attach to the above role 
resource "aws_iam_role_policy" "ecs_access" {
    name = "ecs_access"
    role = "${aws_iam_role.ecs_instance.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

### ECS Service Role ###
# Trust definition for ECS service role
data "aws_iam_policy_document" "trust2" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# Define the service role and apply the above trust
resource "aws_iam_role" "ecsServiceRole" {
    name = "ecsServiceRole"
    assume_role_policy = "${data.aws_iam_policy_document.trust2.json}"
}

# Actual policy to attach to the above role 
resource "aws_iam_role_policy" "ecsServiceRole" {
    name = "ecsServiceRole"
    role = "${aws_iam_role.ecsServiceRole.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"        
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

