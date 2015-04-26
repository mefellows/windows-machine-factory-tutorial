variable "access_key" {}
variable "secret_key" {}
variable "ami_id" {}
variable "subnet-east-1e" {}
variable "subnet-east-1d" {}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "us-east-1"
}
 
resource "aws_elb" "machine-factory-main" {
  name = "machine-factory-main"
  subnets = [ "${subnet-east-1d}", "${subnet-east-1e}" ]
  cross_zone_load_balancing = true
  security_groups = [ "${aws_security_group.allow_web.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
 
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 30
    target = "HTTP:80/"
    interval = 60
  }
 
  cross_zone_load_balancing = true
}
 
resource "aws_launch_configuration" "machine-factory-v1" {
    name = "machine-factory-v1"
    image_id = "${ami_id}"
    security_groups = [ "${aws_security_group.allow_web.id}"]
    instance_type = "t2.small"
}
 
resource "aws_autoscaling_group" "machine-factory-v1" {
  availability_zones = ["us-east-1e", "us-east-1d"]
  name = "machine-factory-v1"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  health_check_grace_period = 60
  health_check_type = "EC2"
  force_delete = false
  launch_configuration = "${aws_launch_configuration.machine-factory-v1.name}"
  load_balancers = ["${aws_elb.machine-factory-main.name}"]
  vpc_zone_identifier = [ "${subnet-east-1d}", "${subnet-east-1e}" ]
}

resource "aws_security_group" "allow_web" {
  name = "allow_web"
  description = "Allow port 80"
  vpc_id = "vpc-6d782708"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 5985
      to_port = 5985
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}