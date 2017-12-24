#!/bin/bash
# Drew Holt <drewderivative@gmail.com>
# Delete linked clones VirtualBox machines from ubuntu1604-base
# rename hosts file

######################## Junk
# VBoxManage unregistervm --delete
# for i in {01..04}; do VBoxManage controlvm ubuntu1604-vm$i poweroff; done
# for i in {01..04}; do VBoxManage unregistervm ubuntu1604-vm$i --delete; done
######################## Junk

echo -n "Delete VMs created from this script? [y|n]: "
read yno
case $yno in
  [yY] | [yY][Ee][Ss] )
    echo "Here we go!"

    # Power off, Delete em'
    for i in {01..04}; do
      VBoxManage controlvm ubuntu1604-vm$i poweroff;
      VBoxManage unregistervm ubuntu1604-vm$i --delete;
    done

    # Save a copy of the hosts file
    mv hosts hosts.deleted.$(date +%F.%T)
  ;;

  [nN] | [n|N][O|o] )
    echo "No action taken.";
    exit 1
    ;;

  *) echo "Invalid input"
    ;;

esac
