provider "aws" {
  region  = "${var.default_region}"
  profile = "${var.environment}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

//mesos slaves
resource "aws_instance" "MesosSlave" {
  count = "${var.mesos_slave["count"]}"
  ami                         = "${var.mesos_slave["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.mesos_slave["instance_type"]}"
  availability_zone           = "${var.default_az}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${split(",", var.default-sec-group)}"]
  associate_public_ip_address = true
  #OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = "true"
  }
  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.mesos_slave["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Role", var.mesos_slave["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

//Create the mesos master
resource "aws_instance" "MesosMaster" {
  count = "${var.mesos_master["count"]}"
  ami                         = "${var.mesos_master["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.mesos_master["instance_type"]}"
  availability_zone           = "${var.default_az}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${split(",", var.default-sec-group)}"]
  associate_public_ip_address = true
  #OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = "true"
  }
  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.mesos_master["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Role", var.mesos_master["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

output "master_private_ips" {
    value = "${join("\n", aws_instance.MesosMaster.*.private_ip)}"
}
output "master_public_ips" {
    value = "${join(" ", aws_instance.MesosMaster.*.public_ip)}"
}
output "slave_private_ips" {
    value = "${join(" ", aws_instance.MesosSlave.*.private_ip)}"
} 
output "slave_public_ips" {
    value = "${join(" ", aws_instance.MesosSlave.*.public_ip)}"
} 
resource "null_resource" "cluster" {
  triggers {
    scount = "${var.mesos_master["count"]}"
  }
}
