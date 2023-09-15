#!/bin/bash


# get argument
echo -e "149\n1\n$1\n1\n" | sudo -S ./scripts/openvpn-install.sh

