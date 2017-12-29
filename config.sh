#!/bin/bash

# name of the base install vm in VirtualBox
BASEVM=ubuntu1604-base
echo "Base VM name: " "$BASEVM"

# name of the snapshot of the base install vm
SNAPSHOT=2017.12.13
echo "Snapshot: " "$SNAPSHOT"

# prefix each linked clone to genereate etc ubuntu1604-vm01
BASENAME=ubuntu1604-vm
echo "VM prefix: " "$BASENAME"

# start of the number linked clones to create / delete
START_VM=01
echo "Starting number of VMs: " "$START_VM"

# end of the number linked clones to create / delete, i.e. vm01-vm04
END_VM=04
echo "Ending number of VMs: " "$END_VM"
