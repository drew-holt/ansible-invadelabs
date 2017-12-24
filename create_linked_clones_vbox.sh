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

# create 4 linked clones from ubuntu1604-base snapshot 2017.12.13
for i in {01..04}; do
  VBoxManage clonevm ubuntu1604-base --snapshot 2017.12.13 --options link --name ubuntu1604-vm$i --register;
  VBoxManage startvm --type headless ubuntu1604-vm$i;
done

# add this group to the top of the Ansible hosts file
echo '[vms]' > hosts

# for each VM run the while loop
for i in {01..04}; do
    # loop until the IP and vbox guest utils are online
    while true;
      do
        # NoLoggedInusers was the only property available between IP and guest tools online
        STATE=$(VBoxManage guestproperty get ubuntu1604-vm$i "/VirtualBox/GuestInfo/OS/NoLoggedInUsers")
        sleep 1;
        echo "Sleeping 1 second on ubuntu1604-vm$i becoming available.";

        # if "No Value set!" then the guest is up and ready to break out of the loop
        if [ "$STATE" != "No value set!" ]; then
          # add each host to the Ansible host list as they become online
          VBoxManage guestproperty get ubuntu1604-vm$i "/VirtualBox/GuestInfo/Net/1/V4/IP" | cut -d" " -f2 >> hosts;
          break
        fi
    done
done
