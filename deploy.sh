#!/bin/bash
#
#1)Run terraform to build a 3 node cluster on EC2
#2)Run a script to process the terraform output
#3)into an ansible inventory file
#4)Run ansible to install mesos master and agents
#5)Run sshuttle to create a VPN to the new cluster
#(blame: traiano@gmail.com 09/08/2017)

#NOTE: modify this to where your private key for the ec2 instances is
KEY="yourkey.pem"

#Run terraform
terraform plan -out terraform.plan
terraform apply terraform.plan

#sleep a little to make sure the ec2 nodes come up correctly and stdout stops chatting 
sleep 30

#generate the inventory file
/usr/bin/perl gen_hosts.pl

#Sleep a little since the hosts may still be coming up (sleep longer the bigger the hosts)
sleep 30

#Run ansible
ansible-playbook --private-key=$KEY -i hosts -u ubuntu playbooks/build_mesos_cluster.yaml

#User information and feedback:
echo "Once you've connected via SSHuttle, your mesos UI will be at http://`cat files/master.ip`:5050"

#Run SSHuttle to create a basic VPN to the cluster
sshuttle -e "ssh -i $KEY -l ubuntu" --dns --pidfile=/tmp/sshuttle.pid --remote=`cat files/master_public.ip` 0/0
