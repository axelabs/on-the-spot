# Variables used in other tf files
# 
# To put the secrets outside of source controll, use the
# optional terraform.tfvars file.

variable "aws_access_key" {
  description = "The AWS access key"
  default = "### Put your own key in here ###"
}
variable "aws_secret_key" {
  description = "The AWS secret key"
  default = "### Put your own sec in here ###"
}

variable "aws_region" {
  description = "The AWS region to work on"
  default = "ca-central-1"
}

variable "ssh_public_key" {
  description = "The public key used on ec2 instances"
  default = "### Put your public key here ###"
}
