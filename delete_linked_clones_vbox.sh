#!/bin/bash
# Drew Holt <drew@invadelabs.com>
# Delete linked clones VirtualBox machines from ubuntu1604-base
# rename hosts file

# pull in settings from config.sh
source config.sh

echo -n "Delete VMs created from this script? [y|n]: "
read -r yno
case $yno in
  [yY] | [yY][Ee][Ss] )
    echo "Here we go!"

    # Power off, Delete em'
    for i in $(seq -f "%02g" "$START_VM" "$END_VM"); do
      printf "Power off %s " "$BASENAME$i"; VBoxManage controlvm "$BASENAME$i" poweroff;
      printf "Delete %s " "$BASENAME$i"; VBoxManage unregistervm "$BASENAME$i" --delete;

      printf "\\n"
    done

    # Save a copy of the hosts file
    mv hosts hosts.deleted."$(date +%F.%T)"
  ;;

  [nN] | [n|N][O|o] )
    echo "No action taken.";
    exit 1
    ;;

  *) echo "Invalid input"
    ;;

esac
