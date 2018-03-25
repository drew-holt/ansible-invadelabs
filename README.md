vbox-invadelabs [![Build Status](https://travis-ci.org/invadelabs/vbox-invadelabs.png?branch=master)](https://travis-ci.org/invadelabs/vbox-invadelabs) [![Code Coverage](https://codecov.io/gh/invadelabs/vbox-invadelabs/branch/master/graph/badge.svg)](https://codecov.io/gh/invadelabs/vbox-invadelabs/branch/master)
==================
Creates, destroy, stops, or starts a set amount of Virtual Box Linked VMs. Used with [invadelabs/ansible-invadelabs](https://github.com/invadelabs/ansible-invadelabs) for local testing followed by terraform on cloud provider.

# Create VirtualBox Host-only Adapter network vboxnet0
VBoxManage throws errors when trying to `VBoxMange hostonlyif ipconfig vboxnet0` so create manually:

![vboxnet0 Settings](media/vboxnet0.png)

![vboxnet0 DHCP Settings](media/vboxnet0_dhcp.png)

# Create base VM image from Ubuntu 16.04 Server or CentOS 7
## Create a new VBox with NIC1 on NAT and NIC2 on host-only network vboxnet0
Will turn this into a kickstart file eventually, for now minimum system install and follow the next steps.
![Base Ubuntu VM](media/base_ubuntu_vm.png)

## Configure base VM
Login into new VM, configure admin user, password, and keys. Quick way to copy ssh key to VM:
~~~
ssh-copy-id -i ~/.ssh/id_rsa 192.168.56.100
~~~

Personal preference, set vi for default
~~~
sudo update-alternatives --set editor /usr/bin/vim.basic
~~~

Add password less sudo to /etc/sudoers
~~~
%sudo   ALL=NOPASSWD: ALL
~~~

Install python-minimal for Ansible as it's not included in Ubuntu 16.04
~~~
sudo apt-get install -y python-minimal
~~~

Install vbox guess additions
~~~
$ sudo apt-get install -y dkms
$ curl -O http://download.virtualbox.org/virtualbox/5.2.4/VBoxGuestAdditions_5.2.4.iso
$ sudo mount -o loop VBoxGuestAdditions_5.2.4.iso /mnt
$ cd /mnt
$ sudo ./VBoxLinuxAdditions.run --nox11
$ sudo umount /mnt
$ cd; rm VBoxGuestAdditions_5.2.4.iso
~~~

## Shutdown the VM and take a snapshot
~~~
$ VBoxManage snapshot ubuntu1604-base take 2017.12.13
~~~
![Base Ubuntu VM Snapshot](media/base_ubuntu_vm_snapshot.png)

# Create linked clone VMs
Create linked clones from VM ubuntu1604-base snapshot 2017.12.13
~~~
./create_linked_clones_vbox.sh
~~~

Example output

![Example output of create_linked_clones_vbox.sh](media/create_linked_clones.png)

# Delete Linked Clone VMs ** DESTRUCTIVE **
When ready to clean up; delete the linked clone VMs permanently
~~~
./delete_linked_clones_vbox.sh
~~~

Example output

![Example output of delete_linked_clones_vbox.sh](media/delete_linked_clones.png)

## Start / Stop VMs
To gracefully power down or power up after creation:
```
$ ./start_stop_clones_vbox.sh
Start or stop VMs created from this script? [start|stop]:
```
