Overview:
=========

This directory contains terraform, ansible and some perl and bash scripts to automate the deployment of a mesos cluster with spark on EC2.

How to Use:
==========

1) Customise the variables.tf and deploy.sh with the details of your AWS account and VPC details.
2) Put your ssh private key for ec2 access in the keys/ directory (use the same name as in deploy.sh and variables.tf , or modify it)
3) Run the script deploy.sh (./deploy.sh)

Pre-requisites
==============

On the deployment computer:

Terraform	: 0.88
Ansible		: 2.0.0.1
PERL		: at least 5.8
SSHuttle

How it Works
=============

The script deploy.sh ties together 4 phases of the deployment in the following sequence:

1) Use terraform to create 3 ec2 instances in an AWS VPC.
2) Run a perl script to process the terraform state output into an ansible inventory file

	- yes I know this can be done with terraform  features. I'll add this when I have time :-)

3) Run Ansible playbook to deploy the mesos master and agents, and the sparkPI benchmarck example
4) Run SSHuttle to create a convenient VPN for the user to connect to the mesos master UI and agent UIs

ToDo
====

 - Remove the perl and bash involved, just having Terraform call Ansible
 - Rewrite the ansible to make better use of variables in the playbooks
 - Create better init scripts for mesos
 - Create better init scripts for spark
 - Simplify initial configuration for the user
 - Fix the markdown in this readme :-)
 
