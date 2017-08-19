#Terraform automation for deploying a single master, multiple agent
#mesos cluster in a pre-existing VPC
#
#NOTE: change the following details to customise to your setup:
#
#1) access_key and secret_key defaults to your own AWS key details
#2) vpc and vpc id 
#3) Default security group id
#4) Default subnet ID
#5) Region and Zone (if desired) 
#6) The EC2 ssh key name for instance access via ssh (the name specified here must match the name of the key given to ansible)

variable "access_key" {
 default = "YOUR_ACCESS_KEY"
}

variable "secret_key" {
 default = "YOUR_SECRET_KEY"
}

#Ignore these unless you want to use static IP addressing
variable "static_ip" {
  default = {
    mesos_master = [
      "172.31.0.10",
      "172.31.0.11",
      "172.31.0.12",
      "172.31.0.13",
      "172.31.0.14",
    ]

    mesos_slave = [
      "172.31.0.20",
      "172.31.0.21",
      "172.31.0.22",
      "172.31.0.23",
      "172.31.0.24",
    ]

  }
}

variable "mesos_master" {
  default = {
    ami           = "ami-20069843"
    instance_type = "m4.xlarge"
    instance_name = "mesos-server"
    role          = "mesos-test-master"
    count         = 1 
  }
}

variable "mesos_slave" { 
  default = {  
    ami           = "ami-20069843"
    instance_type = "m4.xlarge"
    instance_name = "mesos-server"
    role          = "mesos-test-slave"
    count         = 2
  }
} 

variable "default_region" {
 default="ap-southeast-1"
}

variable "default_az" {
 default="ap-southeast-1a"
}

variable "environment" {
 default="prod"
}

variable "name" {
  default = "generic-server-cluster"
}

variable "vpc_id" {
  default = "vpc-a3d895c7"
}

variable "default-sec-group" {
    default = "sg-74d1d313"
}

variable "default_subnet" {
  default = "subnet-0099a076"
}

variable "key_name" {
  default = "archdev"
}

variable "zone_id" {
  default = "Z20MWOA995M23U"
}

variable "block_device" {
  default = "ephemeral"
}

variable "env" {
  default = "dev"
}

variable "vpc" {
  default = "vpc-a3d895c7"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "orchestration" {
  default = false
}
