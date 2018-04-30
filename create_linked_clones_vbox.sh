#!/bin/bash
# Drew Holt <drew@invadelabs.com>
# Create x number of linked clones VirtualBox machines from ubuntu1604-base
# write out hosts file for ansible
# set hostname of each new guest
# 
# shellcheck disable=SC2086
# SC2086: Double quote to prevent globbing and word splitting.

# pull in settings from config.sh
source config.sh

# create linked clones from snapshot of base image
function create_vms {
  for i in $(seq -f "%02g" "$START_VM" "$END_VM"); do
    VBoxManage clonevm "$BASEVM" --snapshot "$SNAPSHOT" --options link --name "$BASENAME$i" --register;
    VBoxManage startvm --type headless "$BASENAME$i";
    printf "\\n"
  done
}

# create the Ansible hosts file with the IP of each host as they come online
function hosts_online () {
  # add this group to the top of the Ansible hosts file
  echo '[vms]' > hosts
  echo "Waiting for each VM to become available"
  # for each VM run the while loop
  for i in $(seq -f "%02g" "$START_VM" "$END_VM"); do
      # loop until the IP and vbox guest utils are online
      while true;
        do
          # NoLoggedInusers was the only property available between IP and guest tools online
          STATE=$(VBoxManage guestproperty get "$BASENAME$i" "/VirtualBox/GuestInfo/OS/NoLoggedInUsers")
          sleep 1;
          echo "Sleeping 1s for $BASENAME$i to become available.";

          # if "No Value set!" then the guest is up and ready to break out of the loop
          if [ "$STATE" != "No value set!" ]; then
            # add each host to the Ansible host list as they become available
            VBoxManage guestproperty get "$BASENAME$i" "/VirtualBox/GuestInfo/Net/1/V4/IP" | cut -d" " -f2 >> hosts;
            break
          fi
      done
  done
  printf "\\n"
}

# set hostname based on VM name
function set_hostname () {
  # create a list of VM names, cut to only vmname, and remove double quotes
  VMLIST=$(VBoxManage list vms | grep "$BASENAME" | cut -d" " -f1|  tr -d \");
  echo "Setting hostname based on VM name"
  echo "VM Name and Associated IP"
  for VMNAME in $VMLIST; do
    IP=$(VBoxManage guestproperty get "$VMNAME" "/VirtualBox/GuestInfo/Net/1/V4/IP" | cut -d" " -f2);
    for HOST in $IP; do
      ssh -q -o StrictHostKeyChecking=no "$HOST" -C "echo "$IP $VMNAME" | sudo -tt tee -a /etc/hosts >/dev/null; sudo hostnamectl set-hostname $VMNAME"
      # ssh $HOST -C "sudo sed -i "s/ubuntu-vm-base/$VMNAME/" /etc/hosts; sudo hostnamectl set-hostname $VMNAME";
      echo "$IP $VMNAME";
    done
  done
}

START=$(date +%s)

create_vms;
hosts_online;
set_hostname;

END=$(date +%s)
DIFF=$(echo "$END - $START" | bc)
printf "\\n"
echo "It took $DIFF seconds to complete..."
