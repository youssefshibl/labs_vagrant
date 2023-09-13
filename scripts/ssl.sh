#!/bin/bash

# make signed ssl certificate 
sudo apt update
sudo apt install easy-rsa

mkdir -p /etc/one/easy-rsa-example
cp -a /usr/share/easy-rsa /etc/one/easy-rsa-example

cd /etc/one/easy-rsa-example/easy-rsa

mv vars.example vars

# EASYRSA_DN "org"
# EASYRSA_REQ_COUNTRY
# EASYRSA_REQ_PROVINCE
# EASYRSA_REQ_CITY
# EASYRSA_REQ_ORG
# EASYRSA_REQ_EMAIL        

sed -i /etc/one/easy-rsa-example/easy-rsa/vars -e \
    "/export EASYRSA_REQ_COUNTRY*/ c export EASYRSA_REQ_COUNTRY=\"US\""
sed -i /etc/one/easy-rsa-example/easy-rsa/vars -e \
    "/export EASYRSA_REQ_PROVINCE*/ c export EASYRSA_REQ_PROVINCE=\"CA\""
sed -i /etc/one/easy-rsa-example/easy-rsa/vars -e \
    "/export EASYRSA_REQ_CITY*/ c export EASYRSA_REQ_CITY=\"SanFrancisco\""
sed -i /etc/one/easy-rsa-example/easy-rsa/vars -e \
    "/export EASYRSA_REQ_ORG*/ c export EASYRSA_REQ_ORG=\"Fort-Funston\""
sed -i /etc/one/easy-rsa-example/easy-rsa/vars -e \
    "/export EASYRSA_REQ_EMAIL*/ c export EASYRSA_REQ_EMAIL=mail@host.domain\""
sed -i /etc/one/easy-rsa-example/easy-rsa/vars -e \
    "/export EASYRSA_DN*/ c export EASYRSA_DN=\"org\"" 



./easyrsa init-pki

# make  "./easyrsa build-ca" without input 
echo "make certificat authority without input"
# ./easyrsa build-ca nopass

echo -e "\n\n\n\n\n\n\n\n" | ./easyrsa build-ca nopass

# make  "./easyrsa gen-req server nopass" without prompt

echo -e "\nyes\n" | ./easyrsa gen-req testserver nopass

# make  "./easyrsa sign-req server server" without prompt

echo -e "yes" |  ./easyrsa sign-req server testserver








