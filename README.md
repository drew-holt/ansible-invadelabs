# Install Ansible on host machine
~~~
sudo apt-get install -y ansible
~~~

# Create base VM image from Ubuntu 16.04;
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

Shutdown, snapshot
~~~
$ VBoxManage snapshot ubuntu1604-base take 2017.12.13
~~~

# Create linked clone VMs
Create linked clones from VM ubuntu1604-base snapshot 2017.12.13
~~~
./create_linked_clones_vbox.sh
~~~

*Fix SSH host key checking*

Set proper hostnames for the VMs
~~~
./set_hostname_vbox.sh
~~~

# Delete Linked Clone VMs
Delete the linked clone VMs permenantly
~~~
./delete_linked_clones_vbox.sh
~~~

# Old - added to base image
Ubuntu 16.04 server doesn't come with python, which we need for Ansible.
~~~
ansible-playbook -i hosts install_python.yaml
~~~

# Example Ansible Commands
Ping all hosts
~~~
$ ansible -i hosts all -m ping
~~~

Get the hostname from all VMs in the "vms" group from the hosts file
~~~
$ ansible -i hosts vms -a '/bin/hostname'
~~~

Get python version from all VMs
~~~
$ ansible -i hosts all -a '/usr/bin/python --version'
~~~

Use the shell module to run the shutdown command on all VMs as root (-b)
~~~
$ ansible -i hosts vms -b -a 'shutdown -h now'
~~~

Run the command echo $TERM on all VMs
~~~
$ ansible -i hosts all -m shell -a 'echo $TERM'
~~~

Copy the file motd in the local directoy to all VMs
~~~
$ ansible -i hosts vms -m copy -b -a "src=motd dest=/etc/motd"
~~~

Get facts from all hosts
~~~
$ ansible -i hosts all -m setup
~~~

Increase how many operations occur concurrently
~~~
-f 10
~~~
