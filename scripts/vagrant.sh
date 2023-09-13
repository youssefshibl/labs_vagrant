#!/bin/bash

# make vagrant user with vagrant password
sudo useradd -p $(openssl passwd -1 vagrant) vagrant


# change root password to vagrant
echo 'vagrant\nvagrant' | sudo passwd root
 
# add vagrant to sudoers , not need password to sudo 
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant

# Install Vagrant Insecure key
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
# wget --no-check-certificate \
#   https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
#   -O /home/vagrant/.ssh/authorized_keys
touch /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# update and upgrade
sudo apt update --yes
sudo apt upgrade --yes

# install ssh server
apt install --yes openssh-server
sudo sed -i /etc/ssh/sshd_config -e \
    "/#Author*/ c AuthorizedKeysFile %h/.ssh/authorized_keys"
sudo service ssh restart

# Installing Guest tools
sudo apt install --yes gcc dkms build-essential \
    linux-headers-server