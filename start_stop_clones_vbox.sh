#!/bin/bash

# pull in settings from config.sh
source config.sh

# Power on
function start_vms () {
  for i in $(seq -f "%02g" "$START_VM" "$END_VM"); do

  printf "Power on ubuntu1604-vm%s " "$i"; VBoxManage startvm --type headless ubuntu1604-vm"$i";

  printf "\\n"
  done
}

# Power off
function stop_vms () {
  for i in $(seq -f "%02g" "$START_VM" "$END_VM"); do

  printf "Power off ubuntu1604-vm%s " "$i"; VBoxManage controlvm ubuntu1604-vm"$i" acpipowerbutton;

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

echo -n "Start or stop VMs created from this script? [start|stop]: "
read -r yno
case $yno in
  start )
    echo "Starting"
    start_vms
    hosts_online
  ;;
  stop )
    echo "Stopping"
    stop_vms
  ;;
esac
