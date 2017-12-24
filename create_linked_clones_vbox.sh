#!/bin/bash
# Drew Holt <drewderivative@gmail.com>
# Create x number of linked clones VirtualBox machines from ubuntu1604-base
# write out hosts file for ansible

######################## Junk
# VBoxManage clonevm <Name of VM> --name <New Name> --register
# VBoxManage clonevm ubuntu1604-base --snapshot 2017.12.13 --options link --name ubuntu16.04-vm01 --register
# for i in {01..04}; do VBoxManage clonevm ubuntu1604-base --snapshot 2017.12.13 --options link --name ubuntu1604-vm$i --register; done
# VBoxManage startvm --type headless ubuntu1604-vm2
# for i in {01..04}; do VBoxManage startvm --type headless ubuntu1604-vm$i; done
# VBoxManage guestproperty enumerate ubuntu16.04-vm03
# VBoxManage guestproperty get ubuntu16.04-vm03 "/VirtualBox/GuestInfo/Net/1/V4/IP"
######################## Junk

for i in {01..04}; do
  VBoxManage clonevm ubuntu1604-base --snapshot 2017.12.13 --options link --name ubuntu1604-vm$i --register;
  VBoxManage startvm --type headless ubuntu1604-vm$i;
done

sleep 20;

echo '[vms]' > hosts

for i in {01..04}; do
  VBoxManage guestproperty get ubuntu1604-vm$i "/VirtualBox/GuestInfo/Net/1/V4/IP" | cut -d" " -f2 >> hosts;
done
