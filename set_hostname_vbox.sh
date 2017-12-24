#!/bin/bash
# Drew Holt <drewderivative@gmail.com>
# Set Virtual Box VM names to VM guest hostname's for Ubuntu 16.04

TYPE=ubuntu1604-vm

# create a list of VM names, cut to only vmware, and remove double quotes
VMLIST=$(VBoxManage list vms | grep $TYPE | cut -d" " -f1|  tr -d \");

# print VM name and with it's associated IP
function vmname_ip () {
  echo "VM Name and Associated IP"
  for VM in $VMLIST;
    do printf $VM" "; VBoxManage guestproperty get $VM "/VirtualBox/GuestInfo/Net/1/V4/IP" | cut -d" " -f2;
  done
  printf "\n"
}

# set hostname based on VM name
function set_hostname () {
  echo "Setting hostname based on VM name"
  for VMNAME in $VMLIST;
    do IP=$(VBoxManage guestproperty get $VMNAME "/VirtualBox/GuestInfo/Net/1/V4/IP" | cut -d" " -f2);
      for HOST in $IP;
        do
          ssh $HOST -C "echo $IP $VMNAME | sudo -tt tee -a /etc/hosts >/dev/null; sudo hostnamectl set-hostname $VMNAME"
          #ssh $HOST -C "sudo sed -i "s/ubuntu-vm-base/$VMNAME/" /etc/hosts; sudo hostnamectl set-hostname $VMNAME";
      done
    done
}

vmname_ip;
set_hostname;
