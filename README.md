# Terraform, ECS and a WebApp

This is terraform configuration that launches the training webapp docker container in Amazon EC2 Container Service.

The ECS cluster spans two availability zones and can be easily scaled since its instances are in an ASG.  Two containers are started and are fronted by an application load balancer.

The code was tested with terraform 0.8.7 from an Ubuntu xenial vagrant box.  These are the pre-reqisits and steps:

Start the VM and prep it:
```
vagrant init ubuntu/xenial64 && vagrant up && vagrant ssh
$ sudo apt-get install unzip awscli
$ wget "https://releases.hashicorp.com/terraform/0.8.7/terraform_0.8.7_linux_amd64.zip" && unzip terraform_0.8.7_linux_amd64.zip
```
Checkout the configuration and populate needed variables (Make sure to set the AWS variables, while an ssh key will be generated if need be):
```
$ git clone https://github.com/axelabs/on-the-spot.git && cd on-the-spot/terraform
$ export AWS_ACCESS_KEY_ID=
$ export AWS_SECRET_ACCESS_KEY=
$ export AWS_DEFAULT_REGION=
$ [[ -f ~/.ssh/id_rsa ]] || ssh-keygen -qf ~/.ssh/id_rsa -N ""
$ tee terraform.tfvars << _EOF
aws_access_key = "$AWS_ACCESS_KEY_ID"
aws_secret_key = "$AWS_SECRET_ACCESS_KEY"
aws_region = "$AWS_DEFAULT_REGION"
ssh_public_key = "`cat ~/.ssh/id_rsa.pub`"
_EOF
```
Do terraforming:
```
$ ~/terraform plan && ~/terraform apply
```
Once all resources initialize the webapp container will be accessible via an ALB who's DNS can be obtained as such:
```
$ ~/terraform show|grep dns_name
  dns_name = webapp-$RANDOM.$AWS_DEFAULT_REGION.elb.amazonaws.com
```
