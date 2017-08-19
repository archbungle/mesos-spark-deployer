#!/usr/bin/perl
#generate the ansible hosts file using the 
#terraform output
#blame: traiano@gmail.com - 09/08/2017
#Example of expected output:
#
#Outputs:
#
#master_private_ips = 172.31.29.63
#master_public_ips = 52.221.218.171
#slave_private_ips = 172.31.31.103 172.31.30.130
#slave_public_ips = 52.77.218.161 54.254.244.170
#NOTE: essentially we assume a single master cluster here.

my $state_file="terraform.tfstate";
my $state_show_cmd="terraform show $state_file";
my $master_ip_list="";
my $slave_ip_list="";
my @slave_ips=();
my @master_ips=();
my @master_private_ips=();
my $inventory_file="hosts";
my $master_ip_file="files/master.ip";
my $master_public_ip_file="files/master_public.ip";

open(CMD,"$state_show_cmd |") or die "cannot run command $state_show_cmd\n";
while(<CMD>)
{
 if($_=~/master_public_ips/){
  my @m_parts=split("=",$_);
  $master_ip_list=$m_parts[1];
  @master_ips=split(" ",$master_ip_list)
 }
 if($_=~/master_private_ips/){
  my @m_pparts=split("=",$_);
  $master_private_iplist=$m_pparts[1];
  @master_private_ips=split(" ",$master_private_iplist)
 }
 if($_=~/slave_public_ips/){
  my @s_parts=split("=",$_);
  $slave_ip_list=$s_parts[1];
  $slave_ip_list=~s/\x1b\[[0-9;]*[a-zA-Z]//g;
  @slave_ips=split(" ",$slave_ip_list)
 }
}
close(CMD);

#Create a heredoc to print out
#the hosts file
my $master_header="[masters]";
my $master_content=join("\n",@master_ips);
my $agent_header="[agents]";
my $agent_content=join("\n",@slave_ips);

my $inventory = <<"END_MESSAGE";
$master_header
$master_content

$agent_header
$agent_content

[all:vars]
ansible_python_interpreter=/usr/bin/python2.7
END_MESSAGE

#write out the ansible inventory file
open(OUT,">$inventory_file") or die "cannot open ansible inventory file for writing\n";
print OUT "$inventory\n";
close(OUT);

my $master_priv_ip=join("\n",@master_private_ips);
#write out the master.ip file
open(OUT,">$master_ip_file") or die "cannot open master ip file for writing\n";
print OUT "$master_priv_ip";
close(OUT);

#write out the master_public.ip file
open(OUT,">$master_public_ip_file") or die "cannot open master public ip file for writing\n";
print OUT "$master_content";
close(OUT);

