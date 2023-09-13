#!/bin/bash

# make public key and private key for github ssh and make local ssh config
# make .ssh file 
current_path=$(pwd)

mkdir -p "$current_path/.ssh"
touch "$current_path/.ssh/id_rsa"
# set current path in variable
echo -e "y\n\n\n" | ssh-keygen -t rsa -f "$current_path/.ssh/id_rsa"
git config --local core.sshCommand "ssh -i $current_path/.ssh/id_rsa"

git config core.sshCommand

# change permission of .ssh file
chmod 700 "$current_path/.ssh"
chmod 600 "$current_path/.ssh/id_rsa"
chmod 644 "$current_path/.ssh/id_rsa.pub"


echo $(ssh-add "$current_path/.ssh/id_rsa")




