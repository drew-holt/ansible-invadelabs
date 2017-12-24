#!/bin/bash
# Drew Holt <drewderivative@gmail.com>
# Delete linked clones VirtualBox machines from ubuntu1604-base
# rename hosts file

######################## Junk
# VBoxManage unregistervm --delete
# for i in {01..04}; do VBoxManage controlvm ubuntu1604-vm$i poweroff; done
# for i in {01..04}; do VBoxManage unregistervm ubuntu1604-vm$i --delete; done
######################## Junk

# Power off, Delete em'
for i in {01..04}; do
  VBoxManage controlvm ubuntu1604-vm$i poweroff;
  VBoxManage unregistervm ubuntu1604-vm$i --delete;
done


mv hosts hosts.deleted.$(date +%F.%T)
